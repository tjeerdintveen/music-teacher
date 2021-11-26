//
//  note.swift
//  
//
//  Created by Tjeerd in ‘t Veen on 22/11/2021.
//

// Note and step

import Foundation

/// A representation of a musical note
enum Note: String, Equatable, CaseIterable {
    case a, aSharp
    case b
    case c, cSharp
    case d, dSharp
    case e
    case f, fSharp
    case g, gSharp
    
    /// Turn a string representation, such as  `F` or `C#` into a `Note` type.
    init?(string: String) {
        let rawValue = string.replacingOccurrences(of: "#", with: "Sharp")
        self.init(rawValue: rawValue)
    }
}


extension Note: CustomStringConvertible {
    var description: String {
        self.rawValue
            .replacingOccurrences(of: "Sharp", with: "♯")
            .uppercased()
    }
}

