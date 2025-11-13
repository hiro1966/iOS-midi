import SwiftUI

struct ContentView: View {
    @StateObject private var midiManager = MIDIManager()
    @StateObject private var pattern = SequencerPattern()
    @StateObject private var engine: SequencerEngine
    
    @State private var baseNote: BaseNote = .C3
    @State private var scaleType: ScaleType = .major
    @State private var scaleNotes: [Int] = []
    @State private var showSettings = false
    
    init() {
        let manager = MIDIManager()
        let pat = SequencerPattern()
        let eng = SequencerEngine(pattern: pat, midiManager: manager)
        
        _midiManager = StateObject(wrappedValue: manager)
        _pattern = StateObject(wrappedValue: pat)
        _engine = StateObject(wrappedValue: eng)
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Transport controls at top
                TransportControlsView(
                    engine: engine,
                    pattern: pattern,
                    showSettings: $showSettings
                )
                .padding(.horizontal)
                .padding(.vertical, 8)
                .background(Color(UIColor.systemBackground))
                
                Divider()
                
                // Sequencer grid - takes most of the screen
                SequencerGridView(
                    pattern: pattern,
                    engine: engine,
                    scaleNotes: scaleNotes
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showSettings) {
                SettingsView(
                    midiManager: midiManager,
                    baseNote: $baseNote,
                    scaleType: $scaleType
                )
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
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

// Transport controls (play, stop, tempo)
struct TransportControlsView: View {
    @ObservedObject var engine: SequencerEngine
    @ObservedObject var pattern: SequencerPattern
    @Binding var showSettings: Bool
    
    var body: some View {
        VStack(spacing: 12) {
            // Play/Stop and Settings
            HStack(spacing: 16) {
                Button(action: {
                    if engine.isPlaying {
                        engine.stop()
                    } else {
                        engine.play()
                    }
                }) {
                    HStack(spacing: 8) {
                        Image(systemName: engine.isPlaying ? "stop.fill" : "play.fill")
                            .font(.title2)
                        Text(engine.isPlaying ? "Stop" : "Play")
                            .font(.headline)
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(engine.isPlaying ? Color.red : Color.green)
                    .cornerRadius(10)
                }
                
                Button(action: {
                    pattern.clear()
                }) {
                    Image(systemName: "trash.fill")
                        .font(.title2)
                        .foregroundColor(.white)
                        .frame(width: 50, height: 50)
                        .background(Color.orange)
                        .cornerRadius(10)
                }
                
                Button(action: {
                    showSettings = true
                }) {
                    Image(systemName: "gearshape.fill")
                        .font(.title2)
                        .foregroundColor(.white)
                        .frame(width: 50, height: 50)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
            }
            
            // Tempo control
            HStack(spacing: 12) {
                Button("-") {
                    engine.updateTempo(engine.tempo - 5)
                }
                .buttonStyle(TempoButtonStyle())
                
                VStack(spacing: 2) {
                    Text("TEMPO")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text("\(Int(engine.tempo)) BPM")
                        .font(.headline)
                }
                .frame(maxWidth: .infinity)
                
                Button("+") {
                    engine.updateTempo(engine.tempo + 5)
                }
                .buttonStyle(TempoButtonStyle())
            }
        }
    }
}

struct TempoButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.title2)
            .fontWeight(.bold)
            .foregroundColor(.white)
            .frame(width: 50, height: 44)
            .background(Color.blue)
            .cornerRadius(8)
            .opacity(configuration.isPressed ? 0.7 : 1.0)
    }
}

// Full screen sequencer grid
struct SequencerGridView: View {
    @ObservedObject var pattern: SequencerPattern
    @ObservedObject var engine: SequencerEngine
    let scaleNotes: [Int]
    
    var body: some View {
        GeometryReader { geometry in
            let noteLabelsWidth: CGFloat = 50
            let stepLabelsHeight: CGFloat = 30
            let gridWidth = geometry.size.width - noteLabelsWidth
            let gridHeight = geometry.size.height - stepLabelsHeight
            
            VStack(spacing: 0) {
                // Step numbers
                HStack(spacing: 0) {
                    // Empty corner
                    Rectangle()
                        .fill(Color(UIColor.systemBackground))
                        .frame(width: noteLabelsWidth, height: stepLabelsHeight)
                    
                    // Step labels
                    ForEach(0..<16, id: \.self) { step in
                        Text("\(step + 1)")
                            .font(.system(size: 11, weight: .medium))
                            .frame(width: gridWidth / 16, height: stepLabelsHeight)
                            .background(Color(UIColor.secondarySystemBackground))
                            .border(Color.gray.opacity(0.2), width: 0.5)
                    }
                }
                
                // Grid and note labels
                HStack(spacing: 0) {
                    // Note labels
                    VStack(spacing: 0) {
                        ForEach(0..<scaleNotes.count, id: \.self) { index in
                            Text(noteNumberToName(scaleNotes[index]))
                                .font(.system(size: 13, weight: .semibold))
                                .frame(width: noteLabelsWidth, height: gridHeight / CGFloat(scaleNotes.count))
                                .background(Color(UIColor.secondarySystemBackground))
                                .border(Color.gray.opacity(0.2), width: 0.5)
                        }
                    }
                    
                    // Step grid
                    StepGridView(
                        pattern: pattern,
                        engine: engine,
                        scaleNotes: scaleNotes
                    )
                    .frame(width: gridWidth, height: gridHeight)
                }
            }
        }
        .background(Color(UIColor.systemBackground))
    }
    
    private func noteNumberToName(_ noteNumber: Int) -> String {
        let names = ["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"]
        let octave = (noteNumber / 12) - 1
        let noteIndex = noteNumber % 12
        return "\(names[noteIndex])\(octave)"
    }
}

// Settings sheet
struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var midiManager: MIDIManager
    @Binding var baseNote: BaseNote
    @Binding var scaleType: ScaleType
    
    var body: some View {
        NavigationView {
            Form {
                Section("MIDI Settings") {
                    if midiManager.availableDevices.isEmpty {
                        HStack {
                            Text("No MIDI devices found")
                                .foregroundColor(.secondary)
                            Spacer()
                            Button(action: {
                                midiManager.refreshDevices()
                            }) {
                                Image(systemName: "arrow.clockwise")
                            }
                        }
                    } else {
                        Picker("Device", selection: $midiManager.selectedDevice) {
                            ForEach(midiManager.availableDevices) { device in
                                Text(device.name).tag(Optional(device))
                            }
                        }
                        
                        Picker("MIDI Channel", selection: $midiManager.selectedChannel) {
                            ForEach(0..<16, id: \.self) { channel in
                                Text("Channel \(channel + 1)").tag(UInt8(channel))
                            }
                        }
                    }
                }
                
                Section("Scale Settings") {
                    Picker("Base Note", selection: $baseNote) {
                        ForEach(BaseNote.allCases, id: \.self) { note in
                            Text(note.displayName).tag(note)
                        }
                    }
                    
                    Picker("Scale Type", selection: $scaleType) {
                        ForEach(ScaleType.allCases, id: \.self) { scale in
                            Text(scale.rawValue).tag(scale)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                Section("About") {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0")
                            .foregroundColor(.secondary)
                    }
                    HStack {
                        Text("Tempo Range")
                        Spacer()
                        Text("40-240 BPM")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
