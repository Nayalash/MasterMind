/*
----------------------------------------------------------------------------------
 Program: MasterMind    
 Author: Nayalash Mohammad
 Date: 15-January-2019
 Revision Date: 17-January-2019
 --------------------------------------------------------------------------------- 
 Program Description: This program is a remake of the Mastermind/ Code Breaker Game.
 ---------------------------------------------------------------------------------- 
 Controls:  
 ----------------------------------------------------------------------------------
 // Add Colors >>>
 White = 0
 Black = 1
 Red = 2
 Green = 3
 Blue = 4
 Yellow = 5
 Orange = 6
 Brown = 7
 
// Go To Next Row >>>
 Press Enter Key
 -------------------------------------------------------------------------------------
 */

//PImage bg;

// Define an array that will hold colors
int[] colors = new int[] {color(255), color(0), color(255, 0, 0), color(0, 255, 0), color(0, 0, 255), color(255, 255, 0), color(255, 140, 0), color(139, 69, 19)};
//                         WHITE       BLACK           RED                GREEN            BLUE              YELLOW              ORANGE              BROWN


//define an array that will generate/store the a secret color combination.
int[] secretCode = new int[4];

int pegRow;
int cursor = 0;
boolean guessing = true;


int[][] game = new int[1000][1000]; // set array to random amount 
int[][] helper = new int[1000][1000]; // set array to random amount 


boolean pickUpColor = false;
boolean nextpegRowBeforeAction;
boolean running = true;

void setup() {
  //bg = loadImage("bg.jpg");
  size(350, 350);
  noStroke(); 

  game[0] = (new int[4]); // 4 pegs at the time of action
  helper[0] = (new int[4]); //4 hint blocks to check if your guess is correct 

  for (int i = 0; i < secretCode.length; i++) {
    int randomizer = parseInt(random(colors.length));
    secretCode[i] = colors[randomizer];

    for (int f = 0; f < i; f++) {
      if (secretCode[i] == secretCode[f])
        i--;
    }
  }
}

void draw() {
  background(11,177,247);

  for (int i = 0; i < secretCode.length; i++) {
    if (running) {
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

  if (!running & pegRow < 6) {
    fill(color(75,0,130));
    textSize(100);
    text("Win", 500, 300);
  } else if (!running) {
    fill(color(75,0,130));
    textSize(100);
    text("Oops", 5, 200);
  }
}

void drawPin(int position, int pegRow, int colour) {
  fill(colour);
  ellipse(50 / 2 + 50 * position, (3 * 50) / 2 + 50 * pegRow, 50, 50);
}

void keyPressed() {
  if (running) {
    if(key == ENTER) {
      nextpegRowAfterAction();
      guessing = true;
    }
    if(guessing) {
      addPeg();
    }
  }
}

void addPeg() {
  int index = Integer.valueOf(key) - 49;
  if(index > -1 && index < 8) {
    if(!isDoubleColor(index)) { 
      game[pegRow][cursor] = colors[index];
      cursor++;
      if(cursor >= secretCode.length) {
        guessing = false;
      }
    }
  }
}

boolean isDoubleColor(int index) {
  for(int i = 0; i < game[pegRow].length; i++) {
    if(game[pegRow][i] == colors[index]) {
      return true;
    }
  }
  return false;
}  

void nextpegRowAfterAction() {
  nextpegRowBeforeAction = true;

  for (int i = 0; i < secretCode.length; i++) {
    if (game[pegRow][i] == 0) {
      nextpegRowBeforeAction = false;
    }
  }

  if (nextpegRowBeforeAction) {
    nextpegRowBeforeAction = false;
    sethelper();

    if (running) {
      pegRow++;
      game[pegRow] = new int[4];
      helper[pegRow] = new int[4];
      //reset the cursor
      cursor = 0;
    }
  }

  if (pegRow >= 6) {
    running = false;
  }
}


//CHECKER
void sethelper() {
  int white = 0;
  int black = 0;

  for (int i = 0; i < secretCode.length; i++) {
    for (int f = 0; f < secretCode.length; f++) {
      if (game[pegRow][i] == secretCode[f])
        if (i == f) black++;
        else white++;
    }
  }

  if (black == secretCode.length) {
    running = false;
  }

  for (int i = 0; i < white; i++) {
    helper[pegRow][i] = color(255);
  }

  for (int i = 0; i < black; i++) {
    helper[pegRow][i + white] = color(0);
  }
}
