# WordleInfinite

A fully-featured Wordle game built with SwiftUI, newly offering dynamic word lists, timed challenges, win streak tracking and background themes.

## Problem Statement

- Traditional word-guessing games like Wordle only offer a single daily puzzle and end after one win or loss
- There are no alternate modes or continuous play options to keep users engaged beyond a single round

**Our Solution:**  
- Preserve Wordle’s core rules (5-letter guesses, color feedback)
- Provide infinite random puzzles on demand
- Introduce multiple modes (untimed vs. timed) and light/dark themes
- Implement a win streak counter to keep track of achievements

## Features
- **Unlimited Play**
  - Player can play as long as they want, with endless solutions
  
- **Color Letter Grid Feedback**: 
  - **Green**: Correct letter in correct position.  
  - **Yellow**: Correct letter in wrong position.  
  - **Gray**: Letter not in the word.
  
- **Custom On-Screen Keyboard**
  - A–Z plus Backspace and Enter keys, each reflecting color feedback after each guess

- **Untimed Mode**
  - No clock—play at your own pace

- **Timed Mode**  
  - Includes a mode with a built-in timer of 60 seconds for an extra layer of challenge.

- **Win Streak Counter**  
  - Tracks consecutive wins separately for timed and untimed modes

- **Alerts & Feedback**  
  - Provides user-friendly popups for invalid words and end-of-game results

- **Light/Dark Theme**
  - Provides the option to choose preferred background theme
 
- **Dynamic Word Lists**  
  - Loads solution and guess words from text files (`valid_solutions.txt` and `valid_guesses.txt`) from Kaggle

## Screenshots of the App
<table>
  <tr>
    <td align="center">
      <img
        src="https://github.com/user-attachments/assets/ae995f3f-df15-46c8-b522-4957151c4ace"
        alt="My Image"
        style="width:200px; height:auto; object-fit:cover;"
      /><br>
      <sub>Figure 1. Normal Gameplay, Untimed Mode, Light Mode</sub>
    </td>
    <td align="center">
      <img
        src="https://github.com/user-attachments/assets/b999f74d-480f-4050-8b5e-064f6ab77c3a"
        alt="My Image"
        style="width:200px; height:auto; object-fit:cover;"
      /><br>
      <sub>Figure 2. Win Condition with Pop-up</sub>
    </td>
    <td align="center">
      <img
        src="https://github.com/user-attachments/assets/cff79f63-3d05-4136-9564-bb2bca4314cc" 
        alt="My Image"
        style="width:200px; height:auto; object-fit:cover;"
      /><br>
      <sub>Figure 3. Lose Condition with Pop-up</sub>
    </td>
  </tr>
</table>

<table>
  <tr>
    <td align="center">
      <img
        src="https://github.com/user-attachments/assets/53d72dbc-6542-4a3a-884d-aa495f2cf72e"
        alt="My Image"
        style="width:200px; height:auto; object-fit:cover;"
      /><br>
      <sub>Figure 4. Empty Grid, Untimed Mode, Light Mode, Settings Down</sub>
    </td>
    <td align="center">
      <img
        src="https://github.com/user-attachments/assets/05f8e5d8-d219-4a45-aeef-a19bf0ce9b66"
        alt="My Image"
        style="width:200px; height:auto; object-fit:cover;"
      /><br>
      <sub>Figure 5. Empty Grid, Timed Mode, Dark Mode, Settings Down</sub>
    </td>
    <td align="center">
      <img
        src="https://github.com/user-attachments/assets/565e14b0-347e-4720-900e-61ba7c3ba800"
        alt="My Image"
        style="width:200px; height:auto; object-fit:cover;"
      /><br>
      <sub>Figure 6. Invalid Word Message Error</sub>
    </td>
  </tr>
</table>

<table>
  <tr>
    <td align="center">
      <img
        src="https://github.com/user-attachments/assets/01e3eb5f-7fe1-4e7e-acdf-5605d9166d39"
        alt="My Image"
        style="width:200px; height:auto; object-fit:cover;"
      /><br>
      <sub>Figure 7. Win Condition (Timed Mode) </sub>
    </td>
    <td align="center">
      <img
        src="https://github.com/user-attachments/assets/56c3bcd0-b338-4f90-b8d1-b1f2d1e7dcda"
        alt="My Image"
        style="width:200px; height:auto; object-fit:cover;"
      /><br>
      <sub>Figure 8. "Out of Time" Message </sub>
    </td>
  </tr>
</table>


## Requirements


- Xcode 13 or later  
- iOS 15.0+ / macOS 12.0+  
- Swift 5.5+

## Installation &  How-to-Play

1. Clone the repository:  
   ```bash
   git clone https://github.com/cosettekay/WordleInfinite.git
2. Build and Run with only iPhone emulators (e.g. iPhone16 Pro)
3. Type in your guesses (5-letters dictionary-valid words only) via in-game keyboard or device keyboard
4. Try to guess the word each round based on letter color evaluation
5. You can change modes, change themes and have fun!

## Resources
- https://www.kaggle.com/datasets/bcruise/wordle-valid-words?select=valid_guesses.csv
- https://gist.github.com/joshbuchea/0dc37d452126d15a3e7924ccb13b9a6a

## Acknowledgements
- Small Inspiration from: https://quickbirdstudios.com/blog/wordle-game-swiftui/

