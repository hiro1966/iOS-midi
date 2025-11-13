import Foundation

// Represents a note event in the sequencer
struct NoteEvent: Identifiable, Equatable {
    let id = UUID()
    var pitch: Int // MIDI note number
    var startStep: Int // Starting step (0-15)
    var length: Int // Length in steps (1-16)
    var velocity: UInt8 = 100 // Fixed velocity
    
    var endStep: Int {
        return startStep + length - 1
    }
    
    func containsStep(_ step: Int) -> Bool {
        return step >= startStep && step <= endStep
    }
}

// Represents the sequencer pattern
class SequencerPattern: ObservableObject {
    @Published var notes: [NoteEvent] = []
    let numberOfSteps = 16
    let numberOfTracks = 8
    
    func addNote(pitch: Int, startStep: Int, length: Int) {
        // Remove any overlapping notes on the same pitch
        removeNotesOnPitch(pitch, inRange: startStep..<(startStep + length))
        
        let note = NoteEvent(pitch: pitch, startStep: startStep, length: length)
        notes.append(note)
    }
    
    func removeNote(_ note: NoteEvent) {
        notes.removeAll { $0.id == note.id }
    }
    
    func removeNotesOnPitch(_ pitch: Int, inRange range: Range<Int>) {
        notes.removeAll { note in
            note.pitch == pitch && !(note.endStep < range.lowerBound || note.startStep >= range.upperBound)
        }
    }
    
    func getNotesAtStep(_ step: Int) -> [NoteEvent] {
        return notes.filter { note in
            note.startStep == step
        }
    }
    
    func getNoteAtPosition(pitch: Int, step: Int) -> NoteEvent? {
        return notes.first { note in
            note.pitch == pitch && note.containsStep(step)
        }
    }
    
    func clear() {
        notes.removeAll()
    }
}

// MIDI Device representation
struct MIDIDevice: Identifiable, Equatable {
    let id: Int // MIDI endpoint reference
    let name: String
    
    static func == (lhs: MIDIDevice, rhs: MIDIDevice) -> Bool {
        return lhs.id == rhs.id
    }
}
