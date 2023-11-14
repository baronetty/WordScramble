//
//  ContentView.swift
//  WordScramble
//
//  Created by Leo  on 12.11.23.
//

import SwiftUI

struct ContentView: View {
    @State private var usedWords = [String]()
    @State private var rootWord = ""
    @State private var newWord = ""
    
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showingError = false
    
    @State private var score = 0
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    TextField ("Enter your word", text: $newWord)
                        .textInputAutocapitalization(.never) // keine Großschreibung korrigieren
                }
                Section {
                    ForEach(usedWords, id: \.self) { word in
                        HStack {
                            Image(systemName: "\(word.count).circle") // Anzahl an Buchstaben neben dem Wort
                            Text(word)
                        }
                    }
                }
                
                
            }
            .navigationTitle(rootWord)
            .toolbar {
                Button("New Word", action: startGame)
            }
            .onSubmit(addNewWord) // enter drücken im TextField
            .onAppear(perform: startGame)
            .alert(errorTitle, isPresented: $showingError) {
                Button("Ok") { }
            } message: {
                Text(errorMessage)
            }
          
            Spacer()
            Spacer()
            
            Text("Score: \(score)")
                .font(.title.bold())
                .foregroundStyle(.black)
            
        }
    }
    func addNewWord() {
        // lowercase and trim the word, to make sure we don't add duplicate words with case differences
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)

        guard answer.count > 2 else {
            wordError(title: "To short.", message: "Your word schould at least has three letters.")
            return
        }
        
        guard answer != rootWord else {
            wordError(title: "The New word is the start word", message: "Be more creative!")
            return
        }

        guard isOriginal(word: answer) else {
            wordError(title: "Word used already", message: "Be more original")
            return
        }
        
        guard isPossible(word: answer) else {
            wordError(title: "Word not possible!", message: "You can't spell that word from '\(rootWord)'")
            return
        }
        
        guard isReal(word: answer) else {
            wordError(title: "Word not recognized.", message: "You can't just make them up, you know!")
            return
        }

        usedWords.insert(answer, at: 0)
        newWord = ""
        
        // Punkte aktualisieren
        points()
    }
    
    func startGame() {
        // 1. Find the URL for start.txt in our app bundle
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            // 2. Load start.txt into a string
            if let startWords = try? String(contentsOf: startWordsURL) {
                // 3. Split the string up into an array of strings, splitting on line breaks
                let allWords = startWords.components(separatedBy: "\n")

                // 4. Pick one random word, or use "silkworm" as a sensible default
                rootWord = allWords.randomElement() ?? "silkworm"

                // If we are here everything has worked, so we can exit
                return
            }
        }

        // If we are *here* then there was a problem – trigger a crash and report the error
        fatalError("Could not load start.txt from bundle.")
    }
    
    func isOriginal (word: String) -> Bool {
        !usedWords.contains(word)
    }
    
    func isPossible (word: String) -> Bool {
        var tempWord = rootWord
        
        for letter in word {
            if let pos = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: pos)
            } else {
                return false
            }
        }
        
        return true
        
    }
    
    func isReal (word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        return misspelledRange.location == NSNotFound
    }
    
    func wordError(title: String, message: String) {
        errorTitle = title
        errorMessage = message
        showingError = true
    }
    
    func points() {
        
        
        // you get score += 1 per answer.count
        score += 1
        // you get score += 1 per added answer
        for word in usedWords {
            score += word.count
        }
    }
    
}
#Preview {
    ContentView()
}
