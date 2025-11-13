import SwiftUI

struct ContentView: View {
    @StateObject private var midiManager = MIDIManager()
    @StateObject private var pattern = SequencerPattern()
    @StateObject private var engine: SequencerEngine
    
    @State private var baseNote: BaseNote = .C3
    @State private var scaleType: ScaleType = .major
    @State private var scaleNotes: [Int] = []
    
    init() {
        let manager = MIDIManager()
        let pat = SequencerPattern()
        let eng = SequencerEngine(pattern: pat, midiManager: manager)
        
        _midiManager = StateObject(wrappedValue: manager)
        _pattern = StateObject(wrappedValue: pat)
        _engine = StateObject(wrappedValue: eng)
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                // Header
                HeaderView()
                
                Divider()
                
                // Main content area
                if geometry.size.width > geometry.size.height {
                    // Landscape layout
                    HStack(spacing: 0) {
                        // Left side - Grid
                        VStack {
                            ScaleLabelsView(scaleNotes: scaleNotes)
                            StepGridView(
                                pattern: pattern,
                                engine: engine,
                                scaleNotes: scaleNotes
                            )
                        }
                        .frame(maxWidth: .infinity)
                        
                        Divider()
                        
                        // Right side - Controls
                        ScrollView {
                            ControlPanelView(
                                engine: engine,
                                midiManager: midiManager,
                                pattern: pattern,
                                baseNote: $baseNote,
                                scaleType: $scaleType
                            )
                        }
                        .frame(width: 350)
                    }
                } else {
                    // Portrait layout
                    VStack(spacing: 0) {
                        // Top - Grid
                        VStack {
                            ScaleLabelsView(scaleNotes: scaleNotes)
                            StepGridView(
                                pattern: pattern,
                                engine: engine,
                                scaleNotes: scaleNotes
                            )
                        }
                        .frame(maxHeight: .infinity)
                        
                        Divider()
                        
                        // Bottom - Controls
                        ScrollView {
                            ControlPanelView(
                                engine: engine,
                                midiManager: midiManager,
                                pattern: pattern,
                                baseNote: $baseNote,
                                scaleType: $scaleType
                            )
                        }
                        .frame(height: 350)
                    }
                }
            }
        }
        .onAppear {
            updateScale()
        }
        .onChange(of: baseNote) { _ in
            updateScale()
        }
        .onChange(of: scaleType) { _ in
            updateScale()
        }
    }
    
    private func updateScale() {
        scaleNotes = generateScaleNotes(baseNote: baseNote, scaleType: scaleType).reversed()
    }
}

struct HeaderView: View {
    var body: some View {
        HStack {
            Image(systemName: "music.note.list")
                .font(.title)
            Text("MIDI Step Sequencer")
                .font(.title2)
                .fontWeight(.bold)
            Spacer()
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
    }
}

struct ScaleLabelsView: View {
    let scaleNotes: [Int]
    
    var body: some View {
        HStack(spacing: 0) {
            // Note labels column
            VStack(spacing: 0) {
                ForEach(0..<scaleNotes.count, id: \.self) { index in
                    Text(noteNumberToName(scaleNotes[index]))
                        .font(.system(size: 12, weight: .medium))
                        .frame(width: 40, height: 30)
                        .background(Color(UIColor.secondarySystemBackground))
                        .border(Color.gray.opacity(0.3), width: 0.5)
                }
            }
            
            // Step number labels
            HStack(spacing: 0) {
                ForEach(0..<16, id: \.self) { step in
                    Text("\(step + 1)")
                        .font(.system(size: 10))
                        .frame(maxWidth: .infinity, minHeight: 20)
                        .background(Color(UIColor.secondarySystemBackground))
                        .border(Color.gray.opacity(0.3), width: 0.5)
                }
            }
        }
    }
    
    private func noteNumberToName(_ noteNumber: Int) -> String {
        let names = ["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"]
        let octave = (noteNumber / 12) - 1
        let noteIndex = noteNumber % 12
        return "\(names[noteIndex])\(octave)"
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
