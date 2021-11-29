// Note and step

import Foundation

typealias Scale = Note // E.g. C can be note C or the C major scale

enum Step {
    case whole
    case half
}

/// A representation of a musical note
struct Note: Equatable {
    enum Name: String, CaseIterable {
        case a, b, c, d, e, f, g
    }
    
    enum Accidental: CustomStringConvertible {
        case sharp
        case flat
        case natural
        
        var description: String {
            switch self {
            case .sharp: return "♯"
            case .flat: return "♭"
            case .natural: return ""
            }
        }
    }
    
    static let naturals: [Note] = Name.allCases.map(Note.init)
    
    let name: Name
    let accidental: Accidental
    
    func flatten() -> Note {
        switch accidental {
        case .sharp:
            return Note(name: name, accidental: .natural)
        case .flat:
            fatalError("No support for double flat")
        case .natural:
            return Note(name: name, accidental: .flat)
        }
    }
    
    func sharpen() -> Note {
        switch accidental {
        case .sharp:
            fatalError("No support for double sharp")
        case .flat:
            return Note(name: name, accidental: .natural)
        case .natural:
            return Note(name: name, accidental: .sharp)
        }
    }
    
    var natural: Note {
        return Note(name: name, accidental: .natural)
    }
    
}

extension Note {
    
    init(name: Name) {
        self.name = name
        self.accidental = .natural
    }
    
    init?(string: String) {
        var iterator = string.makeIterator()
        guard let nameStr = iterator.next(),
              let name = Note.Name(rawValue: String(nameStr).lowercased()) else {
           return nil
        }
        
        if let accidentalStr = iterator.next() {
            
            let accidental: Note.Accidental
            switch accidentalStr {
            case "#": accidental = Accidental.sharp
            case "b": accidental = Accidental.flat
            default:
                return nil
            }
            
            self = Note(name: name, accidental: accidental)
        } else {
            self = Note(name: name)
        }
    }
    
}

extension Note: CustomStringConvertible {
    var description: String {
        name.rawValue.uppercased() + accidental.description
    }
}
