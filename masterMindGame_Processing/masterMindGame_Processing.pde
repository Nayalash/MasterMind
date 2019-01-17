/*

 ----------------------------------------------------------------------------------
 Program: MasterMind    
 Author: Nayalash Mohammad
 Date: 15-January-2019
 Revision Date: 17-January-2019
 --------------------------------------------------------------------------------- 
 Program Description: This program is a remake of the Mastermind/ Code Breaker Game.
 -----------------------------------------------------------------------------------
 BUGS: SOMETIMES HINTS DO NOT SHOW, MIGHT HAVE TO RESTART PROGRAM
 
 DISCLAIMER***
 
 The Program Will Not Accept Double of a Color
 
 In order for the program to run, some times you may have to press on the window where the graphical output is appearing
 
 
 ---------------------------------------------------------------------------------- 
 Controls:  
 ----------------------------------------------------------------------------------
 // Add Colors >>>
 White = 1
 Black = 2
 Red = 3
 Green = 4
 Blue = 5
 Yellow = 6
 Orange = 7
 Brown = 8
 
 // Go To Next Row >>>
 Press Enter Key
 -------------------------------------------------------------------------------------
 */

  

////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////Define Global Variables/////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////


//-----------------------------------------------------------------------------------
//Load Images
PImage keyPic;
PImage arrow;
PImage board1;


//----------------------------------------------------------------------------------

// Define an array that will hold colors
int[] colors = new int[] {color(255), color(0), color(255, 0, 0), color(0, 255, 0), color(0, 0, 255), color(255, 255, 0), color(255, 140, 0), color(139, 69, 19)};
//                          WHITE         BLACK           RED                GREEN            BLUE              YELLOW              ORANGE              BROWN

int[][] game = new int[1000][1000]; // set array to large amount 
int[][] helper = new int[1000][1000]; // set array to large amount 


//define an array that will store the a secret color combination.
int[] secretCode = new int[4];
//--------------------------------------------------------------------------------------------


// define the number of rows for the pegs to be placed
int pegRow;
//set the peg reset to 0 so it can increase the pegs each time
int finder = 0;


//boolean that check for the hints being applied
boolean guessing = true;
//checks when the game reaches to the next row
boolean nextRow;
//checks if the game is in play. [Running]
boolean play = true;

//---------------------------------------------------------------------------------------------


////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////Setup()/////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////

void setup() {

  //load images from directory
  keyPic = loadImage("key.png"); 
  arrow = loadImage("arrow.png");
  board1 = loadImage("board1.png");
  //---------------------------------------------------------
  size(800, 450); //size of the output screen
  noStroke(); // so that the images are clear 
  //--------------------------------------------------------------
  game[0] = new int[4]; // set 4 pegs at the time of action
  helper[0] = new int[4]; // set 4 hint blocks to check if your guess is correct 
  //--------------------------------------------------------------------

  // randomize the 4 circle combination
  for (int i = 0; i < secretCode.length; i++) {
    int randomizer = int(random(colors.length));
    secretCode[i] = colors[randomizer];
    //make it so that there are no doubles
    for (int f = 0; f < i; f++) {
      if (secretCode[i] == secretCode[f])
        i--; // goes back to last iteration
    }
  }
}

////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////// Draw() ////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////

void draw() {
  background(11, 177, 247); //set the background color
  fetchBoard();
  // load image onto the screen  
  image(keyPic, 450, 20); 

  //when the user has not lost,  display all peg place holders
  if (play && pegRow < 8) {
    image(arrow, 300, 60);
    image(arrow, 300, 120);
    image(arrow, 300, 180);
    image(arrow, 300, 240);
    image(arrow, 300, 300);
    image(arrow, 300, 360);
    image(arrow, 300, 420);
  }


  //---------------------------------------------------------------------------------------

  // shows the answer at the end
  for (int i = 0; i < secretCode.length; i++) {
    if (play) {
     //running 
    } else {
      fill(secretCode[i]);
      ellipse(50 / 2 + 50 * i, 50 / 2, 50, 50);
    }
  }

  // displays the pegs
  for (int i = 0; i < secretCode.length; i++) {
    for (int f = 0; f < game.length; f++) {
      if (game[f][i] != 0) {
        fill(game[f][i]);
        ellipse(50 / 2 + 50 * i, (3 * 50) / 2  + 50 * f, 50, 50);
      }
    }
  }
  // displays the hints
  for (int i = 0; i < secretCode.length; i++) {
    for (int f = 0; f < helper.length; f++) {
      if (helper[f][i] != 0) {
        fill(helper[f][i]);
        ellipse(50 * secretCode.length + 20 + (20 * i), 50 + (50 * f) + 20, 10, 10);
      }
    }
  }

  //---------------------------------------------------------------------------------------

  // Setting the game to Win or Lose
  if (!play & pegRow < 8) {
    fill(color(75, 0, 130));
    textSize(50);
    text("Win", 580, 420);
  } else if (!play) {
    fill(color(75, 0, 130));
    textSize(50);
    image(arrow, 200, 10); // load arrow
    text("Oops", 580, 420);
  }
}

////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////// KEY PRESS FUNCTION ////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////


// Make it go to the Next Row By Pressing the Enter Key

void keyPressed() {
  if (play) {
    if (key == ENTER) {
      nextPegRow(); //go to next row (calling the function)
      guessing = true;
    }
    if (guessing) {
      addPeg(); //adds the pegs to the row
    }
  }
}


////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////// My Methods () //////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////

//------------------------------------------------------------------------------------------------------------------------------------

//Setting a Method to add a peg by key presses.
void addPeg() {
  int index = Integer.valueOf(key) - 49; //the reason for why this is 49, as 49 is the numeric value for '1' key. [CHARACTER VALUES]
  if (index > -1 && index < 8) {
    if (!findDouble(index)) { 
      game[pegRow][finder] = colors[index];
      finder++;
      if (finder >= secretCode.length) {
        guessing = false;
      }
    }
  }
}

//-------------------------------------------------------------------------------------------------------------------------------------
//Allows the program not to accept double of the same colors guesses and answers 

boolean findDouble(int index) {
  for (int i = 0; i < game[pegRow].length; i++) {
    if (game[pegRow][i] == colors[index]) {
      return true;
    }
  }
  return false;
}  

//----------------------------------------------------------------------------------------------------------------------------------
//Hints or Helper Structure
void setHelper() {
  int whiteHint = 0;
  int blackHint = 0;

  //calculates hints
  for (int i = 0; i < secretCode.length; i++) {
    for (int f = 0; f < secretCode.length; f++) {
      if (game[pegRow][i] == secretCode[f])
        if (i == f) blackHint++;
        else whiteHint++;
    }
  }

  //if the row is correct. The game stops its running action.
  if (blackHint == secretCode.length) {
    play = false;
  }

  //initiates the white hint pegs
  for (int i = 0; i < whiteHint; i++) {
    helper[pegRow][i] = color(255);
  }
  //initiates the black hint pegs
  for (int i = 0; i < blackHint; i++) {
    helper[pegRow][i + whiteHint] = color(0);
  }
}

//-------------------------------------------------------------------------------------------------
void nextPegRow() {
  nextRow = true;
  // it wont go to next row unless all spots are filled
  for (int i = 0; i < secretCode.length; i++) {
    if (game[pegRow][i] == 0) {
      nextRow = false;
    }
  }

  if (nextRow) {
    nextRow = false;
    setHelper(); //display the hints
    if (play) {
      pegRow++;
      //increases the row makes it go down

      //changes the pegs and the hints to reset for the next row.
      game[pegRow] = new int[4]; 
      helper[pegRow] = new int[4];
      //reset the finder
      finder = 0;
    }
  }
  // when the guesses is less/equal to the 8 row mark, the game technically ends the play process
  if (pegRow >= 8) {
    play = false;
  }
}

//---------------------------------------------------------------------------------------------------------------------------

//make board
void fetchBoard() {
  fill(75, 0, 130);
  rect(0, 0, 300, 500);
  image(board1,0,45);
}

//--------------------------------END---------------------------------------------------------------
