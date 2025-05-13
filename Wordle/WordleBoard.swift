//  WordleBoard.swift
//  Wordle

import SwiftUI

// MARK: — Extension View

extension View {
    func headerStyle(color: Color) -> some View {
        self.font(.headline)
            .foregroundColor(color)
    }
}

// MARK: — Main View

struct WordleBoardView: View {
    // MARK: State & ViewModel
    @ObservedObject var viewModel = WordleBoardViewModel()
    @State private var showSettings = false
    @State private var mode: GameMode = .untimed

    // Keyboard layout
    private let keyboardRows: [[String]] = [
        ["Q","W","E","R","T","Y","U","I","O","P"],
        ["A","S","D","F","G","H","J","K","L"],
        ["Z","X","C","V","B","N","M","⌫","↵"]
    ]

    // MARK: — Body
    // Compiler Errors: need to divide
    var body: some View {
        ZStack {
            // 1) Full-screen background
            backgroundView
                .ignoresSafeArea()

            // 2) All content extracted to smaller views
            contentView
        }
    }

    // MARK: — 2A) Content View

    private var contentView: some View {
        navigationContainer
    }

    // MARK: — 2B) Navigation Container

    private var navigationContainer: some View {
        NavigationView {
            ZStack {
                // 1) Full-screen theme color beneath everything
                (viewModel.selectedBackground.color ?? Color.backgroundLight)
                    .ignoresSafeArea()

                // 2) Existing padded stack
                mainStack
                    .navigationTitle("")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button {
                                withAnimation { showSettings.toggle() }
                            } label: {
                                Image(systemName: "line.horizontal.3")
                                    .imageScale(.large)
                                    .foregroundColor(
                                        viewModel.selectedBackground.name == "Light"
                                            ? .primaryAccent
                                            : .white
                                    )
                            }
                        }
                    }
                    .toolbarBackground(
                        viewModel.selectedBackground.color ?? .backgroundLight,
                        for: .navigationBar
                    )
                    .toolbarBackground(.visible, for: .navigationBar)
            }
        }
        .navigationViewStyle(.stack)
        .alert(viewModel.gameOverMessage, isPresented: $viewModel.isGameOver) {
            Button("OK") { viewModel.resetGame() }
        }
        .onAppear {
            mode = viewModel.isTimedMode ? .timed : .untimed
            if viewModel.isTimedMode { viewModel.startTimer() }
        }
        .onChange(of: mode) { _, new in
            viewModel.isTimedMode = (new == .timed)
        }
        .onChange(of: viewModel.isTimedMode) { _, new in
            mode = new ? .timed : .untimed
            if new { viewModel.startTimer() } else { viewModel.stopTimer() }
            viewModel.resetGame()
        }
    }


    // MARK: — 2C) Main Stack

    private var mainStack: some View {
        VStack(spacing: 16) {
            if showSettings {
                settingsMenu
                    .transition(.move(edge: .top).combined(with: .opacity))
            }
            headerView
            gridView
            errorView
            //gameOverView
            keyboardView
            //newGameButton
        }
        .padding()
        .background(
                viewModel.selectedBackground.color
                 ?? Color.backgroundLight
           )
    }

    // MARK: — 2D) Toolbar Items

    @ToolbarContentBuilder
    private var toolbarItems: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button {
                withAnimation { showSettings.toggle() }
            } label: {
                Image(systemName: "line.horizontal.3")
                    .imageScale(.large)
                    .foregroundColor(
                        viewModel.selectedBackground.name == "Light"
                            ? .primaryAccent : .white
                    )
            }
        }
    }

    // MARK: — Subviews

    @ViewBuilder
    private var settingsMenu: some View {
        VStack(spacing: 12) {
            // Light/Dark Theme picker
            Picker("Theme", selection: $viewModel.selectedBackground) {
                ForEach(viewModel.availableBackgrounds, id: \.self) {
                    Text($0.name).tag($0)
                }
            }
            .pickerStyle(.segmented)

            // Game Mode picker
            Picker("Mode", selection: $mode) {
                ForEach(GameMode.allCases) { m in
                    Text(m.displayName).tag(m)
                }
            }
            .pickerStyle(.segmented)
            .onChange(of: mode) { m in
                viewModel.isTimedMode = (m == .timed)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(
                    viewModel.selectedBackground.name == "Light"
                        ? Color.white.opacity(0.5)
                        : Color.backgroundDark.opacity(0.1)
                )
        )
    }

    @ViewBuilder
    private var headerView: some View {
        VStack(spacing: 4) {
            let streak = viewModel.streaks[mode] ?? 0
            Text("🔥 Streak: \(streak)")
                .headerStyle(color: headerTextColor)

            if viewModel.isTimedMode {
                Text("Time: \(viewModel.timeString)")
                    .headerStyle(color: headerTextColor)
            }
        }
        .padding(.top, 8)
    }

    private var gridView: some View {
        MatrixGrid(board: viewModel.letterBoxes)
            .environmentObject(viewModel)
            .padding()
    }

    @ViewBuilder
    private var errorView: some View {
        if !viewModel.errorMessage.isEmpty {
            Text(viewModel.errorMessage)
                .foregroundColor(.red)
                .font(.subheadline)
                .fontWeight(.bold)
                .padding(.top, 2)
                .transition(.opacity)
                .animation(.easeInOut, value: viewModel.errorMessage)
        }
    }
    // Removed for now -> Popup used instead
    @ViewBuilder
    private var gameOverView: some View {
        if !viewModel.gameOverMessage.isEmpty {
            Text(viewModel.gameOverMessage)
                .font(.headline)
                .foregroundColor(.red)
                .padding(.top, 4)
        }
    }

    // MARK: — Keyboard

    private var keyboardView: some View {
        VStack(spacing: 8) {
            ForEach(keyboardRows, id: \.self) { row in
                KeyboardRowView(
                    keys: row,
                    keyColors: viewModel.keyColors,
                    action: handleKeyPress
                )
            }
        }
        .padding(.bottom, 8)
    }
    // Removed for now
    private var newGameButton: some View {
        Button {
            withAnimation { viewModel.resetGame() }
        } label: {
            Text("New Game")
                .font(.title3)
                .foregroundColor(.white)
                .padding(.horizontal, 15)
                .padding(.vertical, 6)
                .background(Color.primaryAccent)
                .cornerRadius(12)
        }
    }

    private var backgroundView: some View {
        Group {
            if let color = viewModel.selectedBackground.color {
                color
            } else if let imgName = viewModel.selectedBackground.imageName {
                Image(imgName)
                    .resizable()
                    .scaledToFill()
            } else {
                // dynamic fallback in case we leave color==nil
                viewModel.selectedBackground.name == "Dark"
                ? Color.backgroundDark
                : Color.backgroundLight
            }
        }
        .ignoresSafeArea()
    }

    // MARK: — Helpers

    private func handleKeyPress(_ key: String) {
        DispatchQueue.main.async {
                switch key {
                case "↵": viewModel.submitGuess()
                case "⌫": viewModel.removeLastLetter()
                default:     viewModel.addLetter(key)
                }
            }
    }
    // MARK: — Keyboard Row Subview
    // To use MacOS keyboard for input

    private struct KeyboardRowView: View {
        let keys: [String]
        let keyColors: [String: Color]
        let action: (String) -> Void

        var body: some View {
            HStack(spacing: 6) {
                ForEach(keys, id: \.self) { key in
                    let ke: KeyEquivalent = {
                        switch key {
                        case "↵":        return .return
                        case "⌫":        return .delete
                        default:
                            return KeyEquivalent(Character(key.lowercased()))
                        }
                    }()

                    Button(action: { action(key) }) {
                        Text(key)
                            .font(.headline)
                            .frame(minWidth: 30, minHeight: 44)
                            .foregroundColor(.white)
                            .background(keyColors[key] ?? .primaryAccent)
                            .cornerRadius(4)
                    }
                    .keyboardShortcut(ke, modifiers: [])
                }
            }
        }
    }
    private var headerTextColor: Color {
        viewModel.selectedBackground.name == "Light"
            ? .primaryAccent
            : .white
    }
}

// MARK: — Previews

struct WordleBoardView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            WordleBoardView().environment(\.colorScheme, .light)
            WordleBoardView().environment(\.colorScheme, .dark)
        }
    }
}
