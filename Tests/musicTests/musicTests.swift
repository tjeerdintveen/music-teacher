import XCTest
import class Foundation.Bundle
import music

final class musicTests: XCTestCase {
    
    func testMajorScales() throws {
        let expectedPairs = [
            ("a", "A B C♯ D E F♯ G♯"),
            ("b", "B C♯ D♯ E F♯ G♯ A♯"),
            ("c", "C D E F G A B"),
            ("d", "D E F♯ G A B C♯"),
            ("e", "E F♯ G♯ A B C♯ D♯"),
            ("g", "G A B C D E F♯"),
            
            // Scales that risk duplicate notes
            ("c#", "C♯ D♯ E♯ F♯ G♯ A♯ B♯"),
            ("f", "F G A B♭ C D E"),
            ("f#", "F♯ G♯ A♯ B C♯ D♯ E♯"),
        ]
        
        let variants = expectedPairs.flatMap { note, expectation in
            [(note.lowercased(), expectation), (note.uppercased(), expectation)]
        }
        
        for (note, expectedScale) in variants {
            let output = try runWithArguments(args: "--scale \(note)")
            XCTAssertEqual(expectedScale, output, "Scale of \(note) is incorrect")
        }
    }
    
    func testMajorChords() throws {
        let expectedPairs = [
            ("c", "C E G"),
            ("d", "D F♯ A"),
            ("g", "G B D"),
        ]
        
        let variants = expectedPairs.flatMap { note, expectation in
            [(note.lowercased(), expectation), (note.uppercased(), expectation)]
        }
        
        for (note, expectedScale) in variants {
            let output = try runWithArguments(args: "\(note)")
            XCTAssertEqual(expectedScale, output, "Signature of \(note) is incorrect")
        }
    }
    
    func testMinorChords() throws {
        let expectedPairs = [
            ("c", "C E♭ G"),
            ("d", "D F A"),
            ("g", "G B♭ D"),
        ]
        
        let variants = expectedPairs.flatMap { note, expectation in
            [(note.lowercased(), expectation), (note.uppercased(), expectation)]
        }
        
        for (note, expectedScale) in variants {
            let output = try runWithArguments(args: "--minor \(note)")
            XCTAssertEqual(expectedScale, output, "Signature of \(note) is incorrect")
        }
    }
    
    func testSignature() throws {
        let expectedPairs = [
            ("g", "F♯"),
            ("a", "F♯ C♯ G♯"),
            ("b", "F♯ C♯ G♯ D♯ A♯"),
            ("c", ""),
            ("d", "F♯ C♯")
        ]
        
        let variants = expectedPairs.flatMap { note, expectation in
            [(note.lowercased(), expectation), (note.uppercased(), expectation)]
        }
        
        for (note, expectedScale) in variants {
            let output = try runWithArguments(args: "--signature \(note)")
            XCTAssertEqual(expectedScale, output, "Signature of \(note) is incorrect")
        }
    }

    private func runWithArguments(args: String) throws -> String {
        // Some of the APIs that we use below are available in macOS 10.13 and above.
        guard #available(macOS 10.13, *) else {
            return ""
        }
        
        let path = productsDirectory.appendingPathComponent("music")

        let process = Process()
        process.executableURL = path
        process.arguments = args.components(separatedBy: " ")

        let pipe = Pipe()
        process.standardOutput = pipe

        try process.run()
        process.waitUntilExit()

        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)
        return output?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
    }
    
    /// Returns path to the built products directory.
    var productsDirectory: URL {
      #if os(macOS)
        for bundle in Bundle.allBundles where bundle.bundlePath.hasSuffix(".xctest") {
            return bundle.bundleURL.deletingLastPathComponent()
        }
        fatalError("couldn't find the products directory")
      #else
        return Bundle.main.bundleURL
      #endif
    }
}

