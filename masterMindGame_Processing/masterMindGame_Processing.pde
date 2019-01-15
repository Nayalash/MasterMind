/*
----------------------------------------------------------------------------------
Program: MasterMind    
 Author: Nayalash Mohammad
 Date: 15-January-2019
 Revision Date: 17-January-2019
--------------------------------------------------------------------------------- 
 Program Description: This program is a remae of the Mastermind/ Code Breaker Game.
---------------------------------------------------------------------------------- 
 Controls:  
----------------------------------------------------------------------------------
 Check The Next Row = 
 Add Colors >>>
 Black = 0
 Red = 
 
 */

int[] colors = new int[] {color(255), color(0), color(255, 0, 0), color(0, 255, 0), color(0, 0, 255), color(255, 255, 0), color(255, 140, 0), color(139, 69, 19)};
int[] secretCode = new int[4];

int row;
int cursor;

int[][] game = new int[1000][1000]; // set array to random amount 
int[][] helper = new int[1000][1000]; // set array to random amount 

boolean pickUpColor = false;
boolean b_submit = true;
boolean running = true;

void setup() {
  size(800, 350);
  noStroke(); 
 
  game[0] = (new int[4]); // 4 pegs at the time of action
  helper[0] = (new int[4]); //4 hint blocks to check if your guess is correct 

  for (int i = 0; i < secretCode.length; i++) {
    int randomizer = parseInt(random(colors.length));
    secretCode[i] = colors[randomizer];

    for (int j = 0; j < i; j++) {
      if (secretCode[i] == secretCode[j])
        i--;
    }
  }
}

void draw() {
  background(100);
  fill(155, 255, 155);
  rect(0, 0, 350, 50);

  if (running) {
    fill(47, 79, 79);
    rect(0, 50 + 50 * row, 350, 50);
  }

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
    for (int j = 0; j < game.length; j++) {
      if (game[j][i] != 0) {
        fill(game[j][i]);
        ellipse(50 / 2 + 50 * i, (3 * 50) / 2  + 50 * j, 50, 50);
      }
    }
  }

  for (int i = 0; i < secretCode.length; i++) {
    for (int j = 0; j < helper.length; j++) {
      if (helper[j][i] != 0) {
        fill(helper[j][i]);
        rect(50 * secretCode.length + 5 + (20 * i), 50 + (50 * j) + 20, 10, 10);
      }
    }
  }

  if (!running && row < 6) {
    fill(color(0, 255, 255));
    textSize(100);
    textAlign(CENTER);
    text("Winner", 350/2, 800/2);
  } else if (!running) {
    fill(color(0, 255, 255));
    textSize(100);
    textAlign(CENTER);
    text("Looser", 350/2, 800/2);
  }

  if (cursor != 0) {
    fill(color(cursor));
    ellipse(mouseX, mouseY, 50 / 2, 50 / 2);
  }
}

void drawPin(int position, int row, int colour) {
  fill(colour);
  ellipse(50 / 2 + 50 * position, (3 * 50) / 2 + 50 * row, 50, 50);
}

void mousePressed() {
  if (running) {
    getCursorColor();
    setgameColor();
    f_submit();
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
    if (mouseX > 50 * i && mouseX < 50 + 50 * i && mouseY > 50 + 50 * row && mouseY < 2 * 50 + 50 * row && cursor == 0) {
      cursor = game[row][i];
      pickUpColor = true;
    }
  }
}

void setgameColor() {
  for (int i = 0; i < secretCode.length; i++) {
    if (mouseX > 50 * i && mouseX < 50 + 50 * i && mouseY > 50 + 50 * row && mouseY < 2 * 50 + 50 * row && cursor != 0) {
      game[row][i] = cursor;

      for (int j = 0; j < secretCode.length; j++) {
        if (game[row][j] == cursor && i != j) {
          game[row][j] = 0;
        }
      }

      if (!pickUpColor) cursor = 0;
    }
  }
}

void f_submit() {
  b_submit = true;

  for (int i = 0; i < secretCode.length; i++) {
    if (game[row][i] == 0) {
      b_submit = false;
    }
  }

  if (b_submit) {
    b_submit = false;
    sethelper();

    if (running) {
      row++;
      game[row] = new int[4];
      helper[row] = new int[4];
    }
  }

  if (row >= 6)
  {
    running = false;
  }
}

void sethelper() {
  int white = 0;
  int black = 0;

  for (int i = 0; i < secretCode.length; i++) {
    for (int j = 0; j < secretCode.length; j++) {
      if (game[row][i] == secretCode[j])
        if (i == j) black++;
        else white++;
    }
  }

  if (black == secretCode.length) {
    running = false;
  }

  for (int i = 0; i < white; i++) {
    helper[row][i] = color(255);
  }

  for (int i = 0; i < black; i++) {
    helper[row][i + white] = color(0);
  }
}
