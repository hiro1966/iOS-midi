import SwiftUI

struct ControlPanelView: View {
    @ObservedObject var engine: SequencerEngine
    @ObservedObject var midiManager: MIDIManager
    @ObservedObject var pattern: SequencerPattern
    
    @Binding var baseNote: BaseNote
    @Binding var scaleType: ScaleType
    
    var body: some View {
        VStack(spacing: 16) {
            // Play/Stop controls
            HStack(spacing: 20) {
                Button(action: {
                    if engine.isPlaying {
                        engine.stop()
                    } else {
                        engine.play()
                    }
                }) {
                    HStack {
                        Image(systemName: engine.isPlaying ? "stop.fill" : "play.fill")
                            .font(.title2)
                        Text(engine.isPlaying ? "Stop" : "Play")
                            .font(.headline)
                    }
                    .foregroundColor(.white)
                    .frame(width: 120, height: 44)
                    .background(engine.isPlaying ? Color.red : Color.green)
                    .cornerRadius(8)
                }
                
                Button(action: {
                    pattern.clear()
                }) {
                    HStack {
                        Image(systemName: "trash.fill")
                        Text("Clear")
                    }
                    .foregroundColor(.white)
                    .frame(width: 100, height: 44)
                    .background(Color.orange)
                    .cornerRadius(8)
                }
            }
            
            Divider()
            
            // Tempo control
            VStack(alignment: .leading, spacing: 8) {
                Text("Tempo: \(Int(engine.tempo)) BPM")
                    .font(.headline)
                
                HStack {
                    Button("-") {
                        engine.updateTempo(engine.tempo - 5)
                    }
                    .buttonStyle(TempoButtonStyle())
                    
                    Slider(value: Binding(
                        get: { engine.tempo },
                        set: { engine.updateTempo($0) }
                    ), in: 40...240, step: 1)
                    
                    Button("+") {
                        engine.updateTempo(engine.tempo + 5)
                    }
                    .buttonStyle(TempoButtonStyle())
                }
            }
            .padding(.horizontal)
            
            Divider()
            
            // MIDI settings
            VStack(alignment: .leading, spacing: 12) {
                Text("MIDI Settings")
                    .font(.headline)
                
                // MIDI Device selection
                HStack {
                    Text("Device:")
                        .frame(width: 80, alignment: .leading)
                    
                    if midiManager.availableDevices.isEmpty {
                        Text("No devices found")
                            .foregroundColor(.gray)
                            .italic()
                        
                        Button(action: {
                            midiManager.refreshDevices()
                        }) {
                            Image(systemName: "arrow.clockwise")
                        }
                    } else {
                        Picker("", selection: $midiManager.selectedDevice) {
                            ForEach(midiManager.availableDevices) { device in
                                Text(device.name).tag(Optional(device))
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                    }
                }
                
                // MIDI Channel selection
                HStack {
                    Text("Channel:")
                        .frame(width: 80, alignment: .leading)
                    
                    Picker("", selection: $midiManager.selectedChannel) {
                        ForEach(0..<16, id: \.self) { channel in
                            Text("\(channel + 1)").tag(UInt8(channel))
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .frame(width: 80)
                }
            }
            .padding(.horizontal)
            
            Divider()
            
            // Scale settings
            VStack(alignment: .leading, spacing: 12) {
                Text("Scale Settings")
                    .font(.headline)
                
                // Base note selection
                HStack {
                    Text("Base Note:")
                        .frame(width: 80, alignment: .leading)
                    
                    Picker("", selection: $baseNote) {
                        ForEach(BaseNote.allCases, id: \.self) { note in
                            Text(note.displayName).tag(note)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .frame(width: 100)
                }
                
                // Scale type selection
                HStack {
                    Text("Scale:")
                        .frame(width: 80, alignment: .leading)
                    
                    Picker("", selection: $scaleType) {
                        ForEach(ScaleType.allCases, id: \.self) { scale in
                            Text(scale.rawValue).tag(scale)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .frame(width: 200)
                }
            }
            .padding(.horizontal)
        }
        .padding()
        .background(Color(UIColor.systemBackground))
    }
}

struct TempoButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.title3)
            .foregroundColor(.white)
            .frame(width: 40, height: 40)
            .background(Color.blue)
            .cornerRadius(8)
            .opacity(configuration.isPressed ? 0.7 : 1.0)
    }
}
