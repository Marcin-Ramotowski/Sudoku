# Sudoku
This program is a desktop implementation of the popular number puzzle game, Sudoku. The design and functionality of the game are based on the Sudoku.com application by EasyBrain Studio available in the Google Play Store.

## Installation and Usage
To run the program, you need to have Matlab installed on your computer and subscribed Sudoku-Generator API from https://rapidapi.com/gregor-i/api/sudoku-generator1. Usage of this API is free for using 1000 objects per day. In the .env file you have to fill such atributes: content-type, X-RapidAPI-Key and X-RapidAPI-Host. Values of the last two atributes you can copy from the code snippet from the right column on the RapidAPI website indicated in this section. Content-type should be set to 'application/octet-stream'. The program is launched by running the Sudoku.m file in Matlab using the standard way for running such scripts, either by clicking the 'Run' button in the top panel or using the keyboard shortcut ctrl+enter.

## How to Play
The game window consists of a board and a control panel at the bottom. The user fills in the board fields by first selecting a button with a number or 'X' letter, which they want to input into the free field of the board. Then, they click on the selected field, and if the number can be placed in the field, it appears as text in that field. When all the fields are completed, then a window is displayed informing the user of the win and allowing the user to choose between restarting or quitting the game.

## Features
The game has the following functionalities:
- At the start of the game, the player selects the difficulty level by clicking on the corresponding button. The player's choice is sent along with a Get request to the API from where a board of the selected difficulty level will be drawn.
- Fields that are pre-filled at the start of the game are inactive, and the player cannot modify their values. These fields do not have a callback.
- The user can have only one button with a number or 'X' letter pressed at a time. If they press another button, the previously pressed one becomes inactive.
- Notes mode - used to record potential values that could be placed in empty fields. To activate it, the user needs to press the 'N' button. Displayed numbers are presented in ascending order and can be both added to and removed from the pool. If the numbers do not fit in a particular field, the rest of the pool is displayed when the user hovers over such a field.
- Eraser - after pressing the 'X' button, the user can remove the content of the previously filled field by clicking on it.
- Fields that the user has filled with a final value (not in notes mode) turn green.
- After filling in all the fields, the user receives a notification about winning the game and can choose to play again or quit the game.
- The game counts the number of remaining moves using the 'moves' variable. The main and most important structure in the whole program is stored in the 'handles' variable. It stores references to the most critical game controls and statistics, such as the number of remaining moves, references to board elements, or the currently selected number by the user.
- The 'guidata' function also plays an important role. In the first call to this function within the 'createSudokuBoard()' function, the program assigns the 'handles' structure to the window that contains the elements of this structure. In the bodies of the functions handling the clicks, the application first passes the button that triggered the event to the 'guidata' function, which returns the current state of the 'handles' structure. At the end of these functions, the state of the 'handles' structure is updated, followed by another call to the 'guidata' function, where the event source and the current 'handles' state are passed again, resulting in the updating of the game window state.

## Room for Improvement
- Tips for the user
- User mistake limits

## Game Interface
![obraz](https://user-images.githubusercontent.com/109000485/233642239-3031915d-9dab-4aa0-9e2a-27a992233f6a.png)

## Credits
This program was created by Marcin Ramotowski using Matlab documentation and his prior experience with creating desktop applications.
