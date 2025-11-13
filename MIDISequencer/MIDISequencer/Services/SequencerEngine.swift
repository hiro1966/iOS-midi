import Foundation
import Combine

class SequencerEngine: ObservableObject {
    @Published var isPlaying = false
    @Published var currentStep = 0
    @Published var tempo: Double = 120.0 // BPM
    
    private var timer: Timer?
    private var activeNotes: Set<UInt8> = [] // Track currently playing notes
    
    var pattern: SequencerPattern
    var midiManager: MIDIManager
    
    init(pattern: SequencerPattern, midiManager: MIDIManager) {
        self.pattern = pattern
        self.midiManager = midiManager
    }
    
    var stepInterval: TimeInterval {
        // Calculate time per 16th note based on tempo
        let quarterNoteTime = 60.0 / tempo
        let sixteenthNoteTime = quarterNoteTime / 4.0
        return sixteenthNoteTime
    }
    
    func play() {
        guard !isPlaying else { return }
        
        isPlaying = true
        currentStep = 0
        scheduleNextStep()
    }
    
    func stop() {
        isPlaying = false
        timer?.invalidate()
        timer = nil
        
        // Send note off for all active notes
        stopAllActiveNotes()
        currentStep = 0
    }
    
    private func scheduleNextStep() {
        guard isPlaying else { return }
        
        timer = Timer.scheduledTimer(withTimeInterval: stepInterval, repeats: false) { [weak self] _ in
            self?.processStep()
        }
    }
    
    private func processStep() {
        guard isPlaying else { return }
        
        // Stop notes that should end at this step
        stopNotesEndingBeforeStep(currentStep)
        
        // Start new notes at this step
        let notesToPlay = pattern.getNotesAtStep(currentStep)
        
        for note in notesToPlay {
            let midiNote = UInt8(note.pitch)
            
            // Send note on
            midiManager.sendNoteOn(note: midiNote, velocity: note.velocity)
            activeNotes.insert(midiNote)
        }
        
        // Move to next step
        currentStep = (currentStep + 1) % pattern.numberOfSteps
        
        // Schedule next step
        scheduleNextStep()
    }
    
    private func stopNotesEndingBeforeStep(_ step: Int) {
        let previousStep = step == 0 ? pattern.numberOfSteps - 1 : step - 1
        
        // Find notes that ended on the previous step
        let endingNotes = pattern.notes.filter { note in
            note.endStep == previousStep
        }
        
        for note in endingNotes {
            let midiNote = UInt8(note.pitch)
            if activeNotes.contains(midiNote) {
                midiManager.sendNoteOff(note: midiNote)
                activeNotes.remove(midiNote)
            }
        }
    }
    
    private func stopAllActiveNotes() {
        for note in activeNotes {
            midiManager.sendNoteOff(note: note)
        }
        activeNotes.removeAll()
    }
    
    func updateTempo(_ newTempo: Double) {
        tempo = max(40.0, min(240.0, newTempo)) // Clamp between 40-240 BPM
        
        // If playing, restart timer with new interval
        if isPlaying {
            timer?.invalidate()
            scheduleNextStep()
        }
    }
}
