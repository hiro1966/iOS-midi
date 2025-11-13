import Foundation
import CoreMIDI

class MIDIManager: ObservableObject {
    @Published var availableDevices: [MIDIDevice] = []
    @Published var selectedDevice: MIDIDevice?
    @Published var selectedChannel: UInt8 = 0 // MIDI channel 0-15 (displayed as 1-16)
    
    private var midiClient = MIDIClientRef()
    private var outputPort = MIDIPortRef()
    
    init() {
        setupMIDI()
        refreshDevices()
    }
    
    deinit {
        if outputPort != 0 {
            MIDIPortDispose(outputPort)
        }
        if midiClient != 0 {
            MIDIClientDispose(midiClient)
        }
    }
    
    private func setupMIDI() {
        var status: OSStatus
        
        // Create MIDI client
        status = MIDIClientCreateWithBlock("MIDISequencerClient" as CFString, &midiClient) { notification in
            // Handle MIDI notifications (device added/removed)
            self.refreshDevices()
        }
        
        if status != noErr {
            print("Error creating MIDI client: \(status)")
            return
        }
        
        // Create output port
        status = MIDIOutputPortCreate(midiClient, "SequencerOutput" as CFString, &outputPort)
        
        if status != noErr {
            print("Error creating MIDI output port: \(status)")
        }
    }
    
    func refreshDevices() {
        var devices: [MIDIDevice] = []
        let destinationCount = MIDIGetNumberOfDestinations()
        
        for i in 0..<destinationCount {
            let endpoint = MIDIGetDestination(i)
            var deviceName: Unmanaged<CFString>?
            
            let status = MIDIObjectGetStringProperty(endpoint, kMIDIPropertyName, &deviceName)
            
            if status == noErr, let name = deviceName?.takeRetainedValue() as String? {
                devices.append(MIDIDevice(id: Int(endpoint), name: name))
            }
        }
        
        DispatchQueue.main.async {
            self.availableDevices = devices
            
            // If selected device is no longer available, clear selection
            if let selected = self.selectedDevice,
               !devices.contains(where: { $0.id == selected.id }) {
                self.selectedDevice = nil
            }
            
            // Auto-select first device if none selected
            if self.selectedDevice == nil && !devices.isEmpty {
                self.selectedDevice = devices.first
            }
        }
    }
    
    func sendNoteOn(note: UInt8, velocity: UInt8) {
        guard let device = selectedDevice else { return }
        sendMIDIMessage([0x90 + selectedChannel, note, velocity], to: device)
    }
    
    func sendNoteOff(note: UInt8) {
        guard let device = selectedDevice else { return }
        sendMIDIMessage([0x80 + selectedChannel, note, 0], to: device)
    }
    
    private func sendMIDIMessage(_ data: [UInt8], to device: MIDIDevice) {
        var packetList = MIDIPacketList()
        var packet = MIDIPacketListInit(&packetList)
        
        let timestamp = mach_absolute_time()
        packet = MIDIPacketListAdd(&packetList, 1024, packet, timestamp, data.count, data)
        
        if packet == nil {
            print("Failed to add MIDI packet")
            return
        }
        
        let endpoint = MIDIEndpointRef(device.id)
        let status = MIDISend(outputPort, endpoint, &packetList)
        
        if status != noErr {
            print("Error sending MIDI message: \(status)")
        }
    }
    
    // Send all notes off (panic)
    func allNotesOff() {
        guard selectedDevice != nil else { return }
        
        for note in 0...127 {
            sendNoteOff(UInt8(note))
        }
    }
}
