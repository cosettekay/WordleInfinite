//
//  WordProvider.swift
//  Wordle
//


import Foundation

struct WordProvider {
    private static var lastWord: String?
    
    // Wordle Datasets for valid solutions and valid guesses
    static let solutionWords: [String] = loadWords(from: "valid_solutions")
    static let allowedWords: [String] = loadWords(from: "valid_guesses")
    
    static func getRandomWord() -> String {
        var newWord: String
        repeat {
            newWord = solutionWords.randomElement() ?? "apple"
        } while newWord == lastWord
        
        lastWord = newWord
        return newWord
    }
    
    // Dictionary check for word validation
    static func isValidWord(_ word: String) -> Bool {
        allowedWords.contains(word.lowercased()) || solutionWords.contains(word.lowercased())
    }

    private static func loadWords(from filename: String) -> [String] {
        guard let path = Bundle.main.path(forResource: filename, ofType: "txt"),
              let content = try? String(contentsOfFile: path) else {
            return []
        }
        let lines = content.components(separatedBy: .newlines)
        return lines.map { $0.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() }
            .filter { !$0.isEmpty }
    }
}
