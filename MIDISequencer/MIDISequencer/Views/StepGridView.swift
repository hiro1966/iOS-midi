import SwiftUI

struct StepGridView: View {
    @ObservedObject var pattern: SequencerPattern
    @ObservedObject var engine: SequencerEngine
    
    let scaleNotes: [Int]
    let numberOfSteps = 16
    let numberOfTracks = 8
    
    @State private var dragStart: (track: Int, step: Int)?
    @State private var dragEnd: (track: Int, step: Int)?
    
    var body: some View {
        GeometryReader { geometry in
            let cellWidth = geometry.size.width / CGFloat(numberOfSteps)
            let cellHeight = geometry.size.height / CGFloat(numberOfTracks)
            
            ZStack(alignment: .topLeading) {
                // Background grid
                VStack(spacing: 0) {
                    ForEach(0..<numberOfTracks, id: \.self) { track in
                        HStack(spacing: 0) {
                            ForEach(0..<numberOfSteps, id: \.self) { step in
                                Rectangle()
                                    .fill(getCellColor(track: track, step: step))
                                    .frame(width: cellWidth, height: cellHeight)
                                    .border(Color.gray.opacity(0.3), width: 0.5)
                            }
                        }
                    }
                }
                
                // Notes overlay
                ForEach(pattern.notes) { note in
                    if let trackIndex = scaleNotes.firstIndex(of: note.pitch) {
                        NoteRectangle(
                            note: note,
                            trackIndex: trackIndex,
                            cellWidth: cellWidth,
                            cellHeight: cellHeight
                        )
                    }
                }
                
                // Current step indicator
                if engine.isPlaying {
                    Rectangle()
                        .fill(Color.red.opacity(0.25))
                        .frame(width: cellWidth - 1, height: geometry.size.height)
                        .offset(x: CGFloat(engine.currentStep) * cellWidth + 0.5)
                        .allowsHitTesting(false)
                        .animation(.linear(duration: 0.05), value: engine.currentStep)
                }
            }
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        handleDrag(value: value, cellWidth: cellWidth, cellHeight: cellHeight)
                    }
                    .onEnded { value in
                        handleDragEnd(value: value, cellWidth: cellWidth, cellHeight: cellHeight)
                    }
            )
        }
    }
    
    private func getCellColor(track: Int, step: Int) -> Color {
        // Highlight every 4 steps
        let isAccented = step % 4 == 0
        
        // Alternate track colors for better visibility
        let evenTrackBase = Color.gray.opacity(0.05)
        let oddTrackBase = Color.gray.opacity(0.12)
        let evenTrackAccent = Color.gray.opacity(0.1)
        let oddTrackAccent = Color.gray.opacity(0.18)
        
        let baseColor = track % 2 == 0 ? evenTrackBase : oddTrackBase
        let accentColor = track % 2 == 0 ? evenTrackAccent : oddTrackAccent
        
        // Check if dragging over this cell
        if let dragStart = dragStart, let dragEnd = dragEnd {
            let startStep = min(dragStart.step, dragEnd.step)
            let endStep = max(dragStart.step, dragEnd.step)
            
            if track == dragStart.track && step >= startStep && step <= endStep {
                return Color.blue.opacity(0.4)
            }
        }
        
        return isAccented ? accentColor : baseColor
    }
    
    private func handleDrag(value: DragGesture.Value, cellWidth: CGFloat, cellHeight: CGFloat) {
        let step = Int(value.location.x / cellWidth)
        let track = Int(value.location.y / cellHeight)
        
        guard step >= 0 && step < numberOfSteps && track >= 0 && track < numberOfTracks else {
            return
        }
        
        if dragStart == nil {
            dragStart = (track: track, step: step)
        }
        dragEnd = (track: track, step: step)
    }
    
    private func handleDragEnd(value: DragGesture.Value, cellWidth: CGFloat, cellHeight: CGFloat) {
        defer {
            dragStart = nil
            dragEnd = nil
        }
        
        guard let start = dragStart, let end = dragEnd else {
            return
        }
        
        // Only allow horizontal dragging on the same track
        guard start.track == end.track else {
            return
        }
        
        guard scaleNotes.indices.contains(start.track) else {
            return
        }
        
        let pitch = scaleNotes[start.track]
        let startStep = min(start.step, end.step)
        let endStep = max(start.step, end.step)
        let length = endStep - startStep + 1
        
        // Check if tapping on existing note to delete it
        if length == 1, let existingNote = pattern.getNoteAtPosition(pitch: pitch, step: startStep) {
            // Delete the note
            pattern.removeNote(existingNote)
        } else {
            // Add new note
            pattern.addNote(pitch: pitch, startStep: startStep, length: length)
        }
    }
}

struct NoteRectangle: View {
    let note: NoteEvent
    let trackIndex: Int
    let cellWidth: CGFloat
    let cellHeight: CGFloat
    
    var body: some View {
        RoundedRectangle(cornerRadius: 6)
            .fill(
                LinearGradient(
                    colors: [Color.blue, Color.blue.opacity(0.8)],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .strokeBorder(Color.blue.opacity(0.8), lineWidth: 1)
            )
            .frame(
                width: cellWidth * CGFloat(note.length) - 4,
                height: cellHeight - 4
            )
            .offset(
                x: CGFloat(note.startStep) * cellWidth + 2,
                y: CGFloat(trackIndex) * cellHeight + 2
            )
    }
}
