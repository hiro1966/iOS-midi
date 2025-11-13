import Foundation

// MIDI note numbers
enum MIDINote: Int, CaseIterable {
    case C1 = 24
    case Cs1 = 25
    case D1 = 26
    case Ds1 = 27
    case E1 = 28
    case F1 = 29
    case Fs1 = 30
    case G1 = 31
    case Gs1 = 32
    case A1 = 33
    case As1 = 34
    case B1 = 35
    case C2 = 36
    case Cs2 = 37
    case D2 = 38
    case Ds2 = 39
    case E2 = 40
    case F2 = 41
    case Fs2 = 42
    case G2 = 43
    case Gs2 = 44
    case A2 = 45
    case As2 = 46
    case B2 = 47
    case C3 = 48
    case Cs3 = 49
    case D3 = 50
    case Ds3 = 51
    case E3 = 52
    case F3 = 53
    case Fs3 = 54
    case G3 = 55
    case Gs3 = 56
    case A3 = 57
    case As3 = 58
    case B3 = 59
    case C4 = 60
    case Cs4 = 61
    case D4 = 62
    case Ds4 = 63
    case E4 = 64
    case F4 = 65
    case Fs4 = 66
    case G4 = 67
    case Gs4 = 68
    case A4 = 69
    case As4 = 70
    case B4 = 71
    case C5 = 72
    case Cs5 = 73
    case D5 = 74
    case Ds5 = 75
    case E5 = 76
    case F5 = 77
    case Fs5 = 78
    case G5 = 79
    case Gs5 = 80
    case A5 = 81
    case As5 = 82
    case B5 = 83
    case C6 = 84
    case Cs6 = 85
    case D6 = 86
    case Ds6 = 87
    case E6 = 88
    case F6 = 89
    case Fs6 = 90
    case G6 = 91
    case Gs6 = 92
    case A6 = 93
    case As6 = 94
    case B6 = 95
    case C7 = 96
    
    var displayName: String {
        let names = ["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"]
        let octave = (rawValue / 12) - 1
        let noteIndex = rawValue % 12
        return "\(names[noteIndex])\(octave)"
    }
}

// Scale type
enum ScaleType: String, CaseIterable {
    case major = "Major"
    case minor = "Minor"
    
    // Scale intervals (semitones from root)
    var intervals: [Int] {
        switch self {
        case .major:
            return [0, 2, 4, 5, 7, 9, 11, 12] // C, D, E, F, G, A, B, C
        case .minor:
            return [0, 2, 3, 5, 7, 8, 10, 12] // C, D, Eb, F, G, Ab, Bb, C (Natural minor)
        }
    }
}

// Base note selection (C1 to C7)
enum BaseNote: Int, CaseIterable {
    case C1 = 24
    case C2 = 36
    case C3 = 48
    case C4 = 60
    case C5 = 72
    case C6 = 84
    case C7 = 96
    
    var displayName: String {
        switch self {
        case .C1: return "C1"
        case .C2: return "C2"
        case .C3: return "C3"
        case .C4: return "C4"
        case .C5: return "C5"
        case .C6: return "C6"
        case .C7: return "C7"
        }
    }
}

// Generate scale notes based on base note and scale type
func generateScaleNotes(baseNote: BaseNote, scaleType: ScaleType) -> [Int] {
    let base = baseNote.rawValue
    return scaleType.intervals.map { base + $0 }
}
