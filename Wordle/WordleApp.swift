//
//  WordleApp.swift
//  Wordle
//

import SwiftUI
import SwiftData

// Main entry point of the app
@main
struct WordleApp: App {
    var body: some Scene {
        WindowGroup {
            WordleBoardView() // Launches the WordleBoardView as the first screen
        }
    }
}
