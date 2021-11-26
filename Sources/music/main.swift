import ArgumentParser

typealias Scale = Note // E.g. C can be note C or the C major scale

/// A step in a scale
enum Step {
    case whole
    case half
}

/// Get the notes from a major scale.
/// - Parameter scale: A scale
/// - Returns: An array of notes folliowing a major scale pattern
func notesIn(scale: Scale) -> [Note] {
    let majorScalePattern: [Step] = [.whole, .whole, .half, .whole, .whole, .whole, .half]
    let notes = Note.allCases.rotated(to: scale)
    
    var index = 0
    var collectedNotes = [notes[0]]
    for step in majorScalePattern.dropLast() {
        if step == .whole {
            index += 2
        } else if step == .half {
            index += 1
        }
        
        collectedNotes.append(notes[index])
    }
    
    return collectedNotes
}

/// The main entrypoint in the application
struct Music: ParsableCommand {
    
    static var configuration = CommandConfiguration(abstract: "Helping you understand music theory.")
    
    @Flag(name: .shortAndLong, help: "List the scale pattern, or pass it a note for its major scale.")
    var scale = false
    
    @Argument(help: "A note or chord")
    var note: String?
    
    mutating func run() throws {
        switch (scale, note?.lowercased()) {
        case (true, let noteStr?): // If we have a scale and a note string...
            if let note = Note(string: noteStr) { // ...we make a new Note..
                let notes = notesIn(scale: note)
                    .map { note in String(describing: note) }
                    .joined(separator: " ")
                print(notes) // ... and print its major scale
            } else {
                // The note couldn't be initialized.
                // Maybe a weird character is passed.
                print("\(noteStr) is not a proper note")
            }
        case (true, nil): // If we have a scale and a note string...
            print("W W H W W W H")
        case (_, let note?) where note == "c":
            // If we only have a c note
            print("C E G")
        case (_, let note?):
            // If we only have any note other than c
            print("Note \(note) is not supported")
        default:
            // If we have no command at all, print the help-message.
            print(Music.helpMessage())
            break
        }
    }
}

Music.main()
