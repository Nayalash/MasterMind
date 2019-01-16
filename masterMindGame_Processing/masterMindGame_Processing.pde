/*

 ----------------------------------------------------------------------------------
 Program: MasterMind    
 Author: Nayalash Mohammad
 Date: 15-January-2019
 Revision Date: 17-January-2019
 --------------------------------------------------------------------------------- 
 Program Description: This program is a remake of the Mastermind/ Code Breaker Game.
 -----------------------------------------------------------------------------------
 
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
//-----------------------------------------------------------------------------------


// Define an array that will hold colors
int[] colors = new int[] {color(255), color(0), color(255, 0, 0), color(0, 255, 0), color(0, 0, 255), color(255, 255, 0), color(255, 140, 0), color(139, 89, 19)};
//                          WHITE         BLACK           RED                GREEN            BLUE              YELLOW              ORANGE              BROWN

//------------------------------------------------------------------------------------

//define an array that will generate/store the a secret color combination.
int[] secretCode = new int[4];

// define the number of rows for the pegs to be placed
int pegRow;
//set the peg reset to 0
int finder = 0;
//boolean that check for the hints being applied
boolean guessing = true;

//--------------------------------------------------------------------------------------------
//Arrays
int[][] game = new int[1000][1000]; // set array to random amount 
int[][] helper = new int[1000][1000]; // set array to random amount 

//--------------------------------------------------------------------------------------------

//check when the game reaches the next row
boolean nextRow;
//check if the game in play.
boolean play = true;

//---------------------------------------------------------------------------------------------


////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////Setup()/////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////

void setup() {

  //load images from directory
  keyPic = loadImage("key.png"); 
  arrow = loadImage("arrow.png");

  size(800, 500); //size of the output screen
  noStroke(); // so that the images are clear 

  game[0] = (new int[4]); // set 4 pegs at the time of action
  helper[0] = (new int[4]); // set 4 hint blocks to check if your guess is correct 

  // randomize the 4 circle combination
  for (int i = 0; i < secretCode.length; i++) {
    int randomizer = parseInt(random(colors.length));
    secretCode[i] = colors[randomizer];

    for (int f = 0; f < i; f++) {
      if (secretCode[i] == secretCode[f])
        i--;
    }
  }
}

////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////// Draw() ////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////

void draw() {
  background(11, 177, 247); //set the background color

  // load image onto the screen  
  image(keyPic, 450, 20); 


  //---------------------------------------------------------------------------------------
  for (int i = 0; i < secretCode.length; i++) {
    if (play) {
    } else {
      fill(secretCode[i]);
      ellipse(50 / 2 + 50 * i, 50 / 2, 50, 50);
    }
  }

  for (int i = 0; i < secretCode.length; i++) {
    for (int f = 0; f < game.length; f++) {
      if (game[f][i] != 0) {
        fill(game[f][i]);
        ellipse(50 / 2 + 50 * i, (3 * 50) / 2  + 50 * f, 50, 50);
      }
    }
  }

  for (int i = 0; i < secretCode.length; i++) {
    for (int f = 0; f < helper.length; f++) {
      if (helper[f][i] != 0) {
        fill(helper[f][i]);
        ellipse(50 * secretCode.length + 20 + (20 * i), 50 + (50 * f) + 20, 10, 10);
      }
    }
  }

  //---------------------------------------------------------------------------------------

  // Initializing the Win Or Lose Algorthim
  if (!play & pegRow < 8) {
    fill(color(75, 0, 130));
    textSize(70);
    text("Win", 270, 180);
  } else if (!play) {
    fill(color(75, 0, 130));
    textSize(70);
    text("Oops", 270, 180);
    image(arrow, 200, 10); // load arrow
  }
}

////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////// KEY PRESS FUNCTION ////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////


// Intialize the Next Row By Pressing the Enter Key
void keyPressed() {
  if (play) {
    if (key == ENTER) {
      nextPegRow();
      guessing = true;
    }
    if (guessing) {
      addPeg();
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
void nextPegRow() {
  nextRow = true;

  for (int i = 0; i < secretCode.length; i++) {
    if (game[pegRow][i] == 0) {
      nextRow = false;
    }
  }

  if (nextRow) {
    nextRow = false;
    setHelper();

    if (play) {
      pegRow++;
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

//Hints or Helper Structure
void setHelper() {
  int whiteHint = 0;
  int blackHint = 0;

  for (int i = 0; i < secretCode.length; i++) {
    for (int f = 0; f < secretCode.length; f++) {
      if (game[pegRow][i] == secretCode[f])
        if (i == f) blackHint++;
        else whiteHint++;
    }
  }

  if (blackHint == secretCode.length) {
    play = false;
  }

  for (int i = 0; i < whiteHint; i++) {
    helper[pegRow][i] = color(255);
  }

  for (int i = 0; i < blackHint; i++) {
    helper[pegRow][i + whiteHint] = color(0);
  }
}

//--------------------------------END---------------------------------------------------------------
