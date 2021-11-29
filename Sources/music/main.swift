import ArgumentParser

private extension Note {
    var value: Int {
        switch accidental {
        case .natural: return 0
        case .flat: return -1
        case .sharp: return 1
        }
    }
}

/// Get the notes from a major scale.
/// - Parameter scale: A scale
/// - Returns: An array of notes folliowing a major scale pattern
func notesIn(scale: Scale) -> [Note] {
    func augment(previousNote: Note, note: Note, step: Step) -> Note {
        let missesAccidental = previousNote.name == .b || previousNote.name == .e
        let halfStepValue = missesAccidental ? 1 : 0
        let stepValue = step == .whole ? 2 : 1
        
        let totalValue = previousNote.value + stepValue + halfStepValue
        
        switch totalValue {
        case 1: return note.flatten()
        case 2: return note.natural
        case 3: return note.sharpen()
        default:
            fatalError("Unsupported \(totalValue)")
        }
    }
    
    let majorScalePattern: [Step] = [.whole, .whole, .half, .whole, .whole, .whole, .half]
    let notes = Note.naturals.rotated(to: scale.natural)
    
    var previousNote: Note = scale // Scale note is first note, no augmentations
    var augmentedNotes = [previousNote]
    for (note, step) in zip(notes.dropFirst(), majorScalePattern) {
        let augmentedNote = augment(previousNote: previousNote, note: note, step: step)
        augmentedNotes.append(augmentedNote)
        previousNote = augmentedNote
    }

    return augmentedNotes
}

func majorChordFor(note: Note) -> [Note] {
    let notes = notesIn(scale: note)
    return [notes[0], notes[2], notes[4]]
}

func minorChordFor(note: Note) -> [Note] {
    let notes = notesIn(scale: note)
    return [notes[0], notes[2].flatten(), notes[4]]
}

func keySignature(note: Note) -> [Note] {
    let chars = "beadgcf"
    let order = note.accidental == .flat ? String(chars.reversed()) : chars
    return notesIn(scale: note).filter { note in note.accidental != .natural }.sorted { lhs, rhs in
        order.firstIndex(of: Character(lhs.name.rawValue))! > order.firstIndex(of: Character(rhs.name.rawValue))!
    }
}

struct Music: ParsableCommand {
    
    static var configuration = CommandConfiguration(abstract: "Helping you understand music theory.")
    
    @Flag(name: .shortAndLong, help: "List the scale pattern, or pass it a note for its major scale.")
    var scale = false
    
    @Argument(help: "A note or chord")
    var note: String?
    
    @Flag(name: .shortAndLong, help: "Switch to minor (chords only).")
    var minor = false
    
    @Flag(name: .long, help: "")
    var signature = false
    
    mutating func run() throws {
        switch (scale, signature, note.flatMap(Note.init)) {
        case (true, _, let scale?):
            // Specific scale
            print(notesIn(scale: scale).description)
        case (true, _, nil):
            // Scale and no note.
            print("W W H W W W H")
        case (_, true, let note?):
            print(keySignature(note: note).description)
        case (_, _, let note?) where minor:
            print(minorChordFor(note: note).description)
        case (_, _, let note?):
            print(majorChordFor(note: note).description)
        default:
            // If we have no command at all, print the help-message.
            print(Music.helpMessage())
            break
        }
    }
}

extension Array {
    var description: String {
        self.map { String(describing: $0) }.joined(separator: " ")
    }
}

Music.main()
