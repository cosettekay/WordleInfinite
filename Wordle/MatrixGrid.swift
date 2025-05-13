//
//  MatrixGrid.swift
//  Wordle
//

import SwiftUI

struct MatrixGrid: View {
    @EnvironmentObject var viewModel: WordleBoardViewModel
    
    var board: [[LetterBox]] // 2D array of LetterBox
    
    var body: some View {
        VStack(spacing: 8) {
            ForEach(0..<board.count, id: \.self) { row in
                HStack(spacing: 8) {
                    ForEach(0..<board[row].count, id: \.self) { col in
                        board[row][col]
                            .environmentObject(viewModel)
                    }
                }
            }
        }
    }
}
