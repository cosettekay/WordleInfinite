import SwiftUI

// Single Letter box view
struct LetterBox: View {
    let letter: Character?
    let evaluation: LetterEvaluation?

    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var viewModel: WordleBoardViewModel

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 6)
                .fill(boxBackgroundColor)
                .background(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color.emptyBox, lineWidth: 2)
                )
                .frame(width: 50, height: 50)
                .aspectRatio(1, contentMode: .fit)
            if let letter = letter {
                Text(String(letter).uppercased())
                    .font(.largeTitle)
                    .foregroundColor(letterColor)
            }
        }
    }

    private var boxBackgroundColor: Color {
        guard let evaluation = evaluation else {
            return viewModel.selectedBackground.color ?? Color.white
        }
        return evaluation.dynamicColor(for: colorScheme)
    }

    private var letterColor: Color {
        if evaluation == nil {
            return viewModel.selectedBackground.name == "Light" ? .black : .white
        } else {
            return .white
        }
    }
}

private extension LetterEvaluation {
    func dynamicColor(for colorScheme: ColorScheme) -> Color {
        switch self {
        case .noMatch:
            return .emptyBox
        case .correct:
            return .correct
        case .misplaced:
            return .misplaced
        }
    }
}

enum LetterEvaluation {
    case noMatch
    case correct
    case misplaced
}
