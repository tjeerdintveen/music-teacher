//
//  Array+rotate.swift
//  
//
//  Created by Tjeerd in ‘t Veen on 22/11/2021.
//

import Foundation

extension Array where Element: Equatable {
    
    /// Rotate the elements in an array to its element.
    /// The target element becomes the first element. Elements _before_ the passed element will be appended on the end.
    /// - Parameter element: The target element to rotate to.
    /// - Returns: A new array with `element` as the first element.
    ///
    /// Example: We rotate the characters to a "c".
    ///
    ///
    ///     let rotatedElements = Array("abcdefg").rotated(to: "c")
    ///     print(rotatedElements) // ["c", "d", "e", "f", "g", "a", "b"]
    ///
    func rotated(to element: Element) -> [Element] {
        guard let index = firstIndex(of: element) else {
            return self
        }
        
        return Array(self[index...] + self[..<index])
    }
}
