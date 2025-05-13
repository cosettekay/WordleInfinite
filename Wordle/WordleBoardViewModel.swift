// WordleBoardViewModel3.swift
import SwiftUI
import Combine

// MARK: — Background Options

struct BackgroundOption: Hashable {
    let name: String
    let color: Color?
    let imageName: String?
}

// MARK: — Game Mode
// Game Mode: Timed (60s) vs Untimed
enum GameMode: String, CaseIterable, Identifiable {
    case untimed, timed
    var id: String { rawValue }
    var displayName: String { rawValue.capitalized }
}

// MARK: — ViewModel

class WordleBoardViewModel: ObservableObject {
    // MARK: Variables
    
    @Published var letterBoxes: [[LetterBox]] = []
    @Published var currentGuess: String = ""
    @Published var isGameOver: Bool = false
    @Published var gameOverMessage: String = ""
    @Published var errorMessage: String = ""
    @Published var keyColors: [String: Color] = [:]
    @Published var selectedBackground: BackgroundOption
    @Published var isTimedMode: Bool = false
    @Published private(set) var timeElapsed: Int  = 0
    @Published private(set) var timeString: String = "00:00"
    @Published private(set) var streaks: [GameMode: Int] = [
        .untimed: 0,
        .timed:   0
    ]

    // MARK: Configuration

    let availableBackgrounds: [BackgroundOption] = [
        BackgroundOption(
            name: "Light",
            color: .backgroundLight,
            imageName: nil
        ),
        BackgroundOption(
            name: "Dark",
            color: .backgroundDark,
            imageName: nil
        )
    ]
    // Guess Conditions
    let wordLength  = 5
    let maxAttempts = 6
    private let timeLimit = 60

    // MARK: Game Initiliazed

    private var currentRow = 0
    private var targetWord  = WordProvider.getRandomWord()
    private var timer: Timer? = nil

    // MARK: Init

    init() {
        // On default, empty board and light mode
        self.selectedBackground = availableBackgrounds[0]
        resetBoard()
    }

    // MARK: — Public Methods

    // Reset Game when User loses/runs out of time
    // or switches Game Mode
    func resetGame() {
        targetWord = WordProvider.getRandomWord()
        currentRow = 0
        currentGuess = ""
        isGameOver = false
        gameOverMessage = ""
        errorMessage = ""
        keyColors = [:]

        // reset timer
        stopTimer()
        timeElapsed = 0
        timeString  = "00:00"

        resetBoard()
        if isTimedMode {
            startTimer()
        }
    }

    // Add a letter
    func addLetter(_ letter: String) {
        guard currentGuess.count < wordLength,
              !isGameOver else { return }
        currentGuess.append(letter.lowercased())
        updateCurrentRow()
    }

    // Backspace one letter
    func removeLastLetter() {
        guard !currentGuess.isEmpty,
              !isGameOver else { return }
        currentGuess.removeLast()
        updateCurrentRow()
    }

    // User submits a valid 5-letter word guess
    func submitGuess() {
        guard currentGuess.count == wordLength, // 5 letters only
              !isGameOver else { return }
        
        // Validate using valid_guesses.txt
        guard WordProvider.isValidWord(currentGuess) else {
            errorMessage = "Not a valid word!"
            return
        }
        errorMessage = ""
        
        // 2-pass Evaluation
        let guess = currentGuess.lowercased()
        var guessArr = Array(guess)
        var targetArr = Array(targetWord)
        var evals = Array(
            repeating: LetterEvaluation.noMatch,
            count: wordLength
        )

        // 1) Mark correct letters
        for i in 0..<wordLength {
            if guessArr[i] == targetArr[i] {
                evals[i] = .correct
                targetArr[i] = "-"
            }
        }

        // 2) Mark misplaced letters
        for i in 0..<wordLength {
            if evals[i] == .noMatch,
               let idx = targetArr.firstIndex(of: guessArr[i]) {
                evals[i] = .misplaced
                targetArr[idx] = "-"
            }
        }

        // 3) Update boxes & keyboard colors
        for i in 0..<wordLength {
            let letter = guessArr[i]
            let evaluation = evals[i]
            letterBoxes[currentRow][i] = LetterBox(letter: letter, evaluation: evaluation)

            let key = String(letter).uppercased()
            switch evaluation {
            case .correct:
                keyColors[key] = .correct
            case .misplaced:
                if keyColors[key] != .correct {
                    keyColors[key] = .misplaced
                }
            case .noMatch:
                if keyColors[key] == nil {
                    keyColors[key] = Color.emptyBox.opacity(0.3)
                }
            }
        }

        // 4) Check for Win
        if guess == targetWord {
            gameOverMessage = "🎉 You guessed it! Word was '\(targetWord.uppercased())'"
            isGameOver = true
            // Streak Counter ++
            let modeKey = isTimedMode ? GameMode.timed : .untimed
            streaks[modeKey, default: 0] += 1
            stopTimer()
            return
        }

        // 5) Advance row if word has not been guessed yet
        currentRow += 1
        currentGuess = ""

        // 6) Check for Loss
        if currentRow >= maxAttempts {
            gameOverMessage = "❌ Out of attempts! Word was '\(targetWord.uppercased())'"
            isGameOver = true
            let modeKey = isTimedMode ? GameMode.timed : .untimed
            streaks[modeKey] = 0
            stopTimer()
        }
    }

    // MARK: — Timer Control (Timed Mode)

    // Schedule a visual timer (60s)
    func startTimer() {
        guard timer == nil else { return }
        timeElapsed = 0
        updateTimeString()

        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self, !self.isGameOver else {
                self?.stopTimer()
                return
            }
            // Increment + Update Timer Display
            self.timeElapsed += 1
            self.updateTimeString()
            
            // After 60 seconds pass, force a loss
            if self.timeElapsed >= self.timeLimit {
                self.gameOverMessage = "⌛ Time’s up! The word was '\(self.targetWord.uppercased())'"
                self.isGameOver = true
                self.stopTimer()
                self.streaks[.timed] = 0
                
                // Start a new round automatically
                //DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                //    self.resetGame()
                //}
            }
        }
    }

    // Stop the countdown timer
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    // MARK: — Private Functions

    // Build empty 2d grid
    private func resetBoard() {
        letterBoxes = Array(
            repeating: Array(
                repeating: LetterBox(letter: nil, evaluation: nil),
                count: wordLength
            ),
            count: maxAttempts
        )
    }

    // Update current row with letters as you type
    private func updateCurrentRow() {
        let chars = Array(currentGuess)
        for i in 0..<wordLength {
            let ch: Character? = i < chars.count ? chars[i] : nil
            letterBoxes[currentRow][i] = LetterBox(letter: ch,
                                                   evaluation: nil)
        }
    }

    // Timer Display Format
    private func updateTimeString() {
        let minutes = timeElapsed / 60
        let seconds = timeElapsed % 60
        timeString = String(format: "%02d:%02d", minutes, seconds)
    }
}
