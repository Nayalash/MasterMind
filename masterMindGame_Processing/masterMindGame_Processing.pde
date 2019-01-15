/*
----------------------------------------------------------------------------------
 Program: MasterMind    
 Author: Nayalash Mohammad
 Date: 15-fanuary-2019
 Revision Date: 17-fanuary-2019
 --------------------------------------------------------------------------------- 
 Program Description: This program is a remae of the Mastermind/ Code Breaker Game.
 ---------------------------------------------------------------------------------- 
 Controls:  
 ----------------------------------------------------------------------------------
 Check The Next pegRow = 
 Add Colors >>>
 Black = 0
 Red = 
 
 */

int[] colors = new int[] {color(255), color(0), color(255, 0, 0), color(0, 255, 0), color(0, 0, 255), color(255, 255, 0), color(255, 140, 0), color(139, 69, 19)};
int[] secretCode = new int[4];

int pegRow;
int cursor;

int[][] game = new int[1000][1000]; // set array to random amount 
int[][] helper = new int[1000][1000]; // set array to random amount 

boolean pickUpColor = false;
boolean nextpegRowBeforeAction;
boolean running = true;

void setup() {
  size(800, 350);
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
  background(150);
  //if (running) {
  //  fill(47, 79, 79);
  //  rect(0, 50 + 50 * pegRow, 350, 50);
  //}

  for (int i = 0; i < secretCode.length; i++) {
    if (running) {
    } else {
      fill(secretCode[i]);
      ellipse(50 / 2 + 50 * i, 50 / 2, 50, 50);
    }
  }

  int width = (int)(50 * (secretCode.length + .25));
  int height = (int)(50 * .25);

  for (int i = 0; i < colors.length; i++) {
    fill(colors[i]);

    if (i == colors.length / 2) {
      width = (int)(50 * (secretCode.length + .25));
      height += 50 / 2;
    }

    ellipse(width, height, 50 / 2, 50 / 2);

    width += 50 / 2;
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
        ellipse(50 * secretCode.length + 5 + (20 * i), 50 + (50 * f) + 20, 10, 10);
      }
    }
  }

  if (!running && pegRow < 6) {
    fill(color(0, 255, 255));
    textSize(100);
    text("Winner", 500, 300);
  } else if (!running) {
    fill(color(0, 255, 255));
    textSize(100);
    text("Oops!!!", 500, 300);
  }

  if (cursor != 0) {
    fill(color(cursor));
    ellipse(mouseX, mouseY, 50 / 2, 50 / 2);
  }
}

void drawPin(int position, int pegRow, int colour) {
  fill(colour);
  ellipse(50 / 2 + 50 * position, (3 * 50) / 2 + 50 * pegRow, 50, 50);
}

void mousePressed() {
  if (running) {
    getCursorColor();
    setgameColor();
    nextpegRowAfterAction();
  }
}

void getCursorColor() {
  for (int i = 0; i < colors.length / 2; i++) {
    if (mouseX > 50 * secretCode.length + i * (50 / 2) && mouseX < 50 * secretCode.length + (i + 1) * 50 && mouseY > 0 && mouseY < 50) {
      cursor = mouseY < 50 / 2 ? colors[i] : colors[i + colors.length / 2];
    }
  }

  pickUpColor = false;

  for (int i = 0; i < secretCode.length; i++) {
    if (mouseX > 50 * i && mouseX < 50 + 50 * i && mouseY > 50 + 50 * pegRow && mouseY < 2 * 50 + 50 * pegRow && cursor == 0) {
      cursor = game[pegRow][i];
      pickUpColor = true;
    }
  }
}

void setgameColor() {
  for (int i = 0; i < secretCode.length; i++) {
    if (mouseX > 50 * i && mouseX < 50 + 50 * i && mouseY > 50 + 50 * pegRow && mouseY < 2 * 50 + 50 * pegRow && cursor != 0) {
      game[pegRow][i] = cursor;

      for (int f = 0; f < secretCode.length; f++) {
        if (game[pegRow][f] == cursor && i != f) {
          game[pegRow][f] = 0;
        }
      }

      if (!pickUpColor) cursor = 0;
    }
  }
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
