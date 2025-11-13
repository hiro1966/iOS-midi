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
            
            ZStack {
                // Background grid
                ForEach(0..<numberOfTracks, id: \.self) { track in
                    ForEach(0..<numberOfSteps, id: \.self) { step in
                        Rectangle()
                            .fill(getCellColor(track: track, step: step))
                            .frame(width: cellWidth, height: cellHeight)
                            .border(Color.gray.opacity(0.3), width: 0.5)
                            .position(x: CGFloat(step) * cellWidth + cellWidth / 2,
                                    y: CGFloat(track) * cellHeight + cellHeight / 2)
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
                        .fill(Color.red.opacity(0.3))
                        .frame(width: cellWidth, height: geometry.size.height)
                        .position(x: CGFloat(engine.currentStep) * cellWidth + cellWidth / 2,
                                y: geometry.size.height / 2)
                        .allowsHitTesting(false)
                }
            }
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
        
        // Alternate track colors
        let baseColor = track % 2 == 0 ? Color.gray.opacity(0.1) : Color.gray.opacity(0.2)
        let accentColor = track % 2 == 0 ? Color.gray.opacity(0.15) : Color.gray.opacity(0.25)
        
        // Check if dragging over this cell
        if let dragStart = dragStart, let dragEnd = dragEnd {
            let startStep = min(dragStart.step, dragEnd.step)
            let endStep = max(dragStart.step, dragEnd.step)
            
            if track == dragStart.track && step >= startStep && step <= endStep {
                return Color.blue.opacity(0.3)
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
        guard let start = dragStart, let end = dragEnd else {
            dragStart = nil
            dragEnd = nil
            return
        }
        
        // Only allow horizontal dragging on the same track
        if start.track == end.track {
            let pitch = scaleNotes[start.track]
            let startStep = min(start.step, end.step)
            let endStep = max(start.step, end.step)
            let length = endStep - startStep + 1
            
            // Check if clicking on existing note to delete it
            if length == 1, let existingNote = pattern.getNoteAtPosition(pitch: pitch, step: startStep) {
                pattern.removeNote(existingNote)
            } else {
                // Add new note
                pattern.addNote(pitch: pitch, startStep: startStep, length: length)
            }
        }
        
        dragStart = nil
        dragEnd = nil
    }
}

struct NoteRectangle: View {
    let note: NoteEvent
    let trackIndex: Int
    let cellWidth: CGFloat
    let cellHeight: CGFloat
    
    var body: some View {
        RoundedRectangle(cornerRadius: 4)
            .fill(Color.blue)
            .frame(width: cellWidth * CGFloat(note.length) - 2,
                   height: cellHeight - 2)
            .position(x: CGFloat(note.startStep) * cellWidth + (cellWidth * CGFloat(note.length)) / 2,
                     y: CGFloat(trackIndex) * cellHeight + cellHeight / 2)
    }
}
