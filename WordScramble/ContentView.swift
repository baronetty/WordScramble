//
//  ContentView.swift
//  WordScramble
//
//  Created by Leo  on 12.11.23.
//

import SwiftUI

struct ContentView: View {
    let people = ["Finn", "Leia", "Luke", "Rey"]
    
    var body: some View {
        List {
            Text("Static Row")
            ForEach (people, id: \.self) {
                Text("\($0)")
            }
            Text("Static Row")
        }
    }
    func testBundles () {
        if let fileURL = Bundle.main.url(forResource: "someFile", withExtension: "txt"){
            if let fileContents = try? String(contentsOf: fileURL) {
                // we loaded the file into a string
            }
        }
    }
    
    func testStrings () {
        let input = """
        a
        b
        c
        """
        let letters = input.components(separatedBy: "\n") // gives back an array of three components
        let letter = letters.randomElement()
        let trimmed = letter?.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func testUI () {
        let word = "Swift" // we wanne check that word for correct spelling
        let checker = UITextChecker()
        
        let range = NSRange(location: 0, length: word.utf16.count) // utf16 is a bridging format, that Swift know how to read Object-C
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        let allGood = misspelledRange.location == NSNotFound // gives back true or false -> failure found or not
    }
}
#Preview {
    ContentView()
}
