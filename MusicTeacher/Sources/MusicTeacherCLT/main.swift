import MusicTeacher
import Music
import Foundation

struct Prompt: CustomStringConvertible {
    let question: String
    let expectedAnswer: [Note]
    
    var description: String {
        question
    }
}

func makePrompt() -> Prompt {
    guard let note = Note.naturals.randomElement() else {
        fatalError("Could not retrieve note")
    }
    
    let expectedAnswer = Notes.majorChordFor(note: note)
    return Prompt(question: "Teacher: \"What are the notes in the \(note) chord?\"", expectedAnswer: expectedAnswer)
}

print("Teacher: \"Let's begin\"")
var currentPrompt: Prompt = makePrompt()

while true {
    print(currentPrompt)
    guard let value = readLine() else {
        continue
    }
    
    let notes = value
        .components(separatedBy: " ")
        .compactMap(Note.init)
    
    if notes == currentPrompt.expectedAnswer {
        print("Teacher: \"Correct!\"")
        print("")
        print("Teacher: \"Next question:\"")
        currentPrompt = makePrompt()
    } else {
        if notes.count == 3 {
            print("Teacher: \"Sorry wrong answer!\"")
        } else {
            print("Teacher: \"I don't understand that input!\"")
            print("Teacher: \"You can write answers with spaces between the notes\"")
            print("Teacher: \"For example: C D# fb\"")
        }
    }
    print("")
}
