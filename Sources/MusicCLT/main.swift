import ArgumentParser
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
