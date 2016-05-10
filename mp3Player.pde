//meco Aufgabe 1 Marco Agovino, Davina , Ina Widmer, Michael Job

import ddf.minim.*;

AudioPlayer player;
Minim minim;//audio context
int ws = 400;  //windowsize


Button on_button;  // the button
int clk = 1;       // number of times the button is clicked
boolean isPlaying = false;

void setup() {
  size (400, 400);
  minim = new Minim(this);  
  smooth();
  
  // create the button object
  on_button = new Button();
}

void draw() {
  // draw a square if the mouse curser is over the button
  if (on_button.MouseIsOver()) {
    fill(255);
    triangle(ws/2-50, ws/2+50, ws/2-50, ws/2-50, ws/2+50, ws/2); 
  }
  else {
    // hide the square if the mouse cursor is not over the button
    background(0);
  }
  // draw the button in the window
  on_button.Draw();
}

// mouse button clicked
void mouseReleased()
{
  if (on_button.MouseIsOver()) {
    // print some text to the console pane if the button is clicked
    print("Clicked: ");
    println(clk++);    
    //todo: e.g. play audio file
    if(!isPlaying) {
      isPlaying=true;
      player = minim.loadFile("besser.mp3", 2048);
      player.play();
    }
    else {
      isPlaying=false;
      player.close();
      minim.stop();
    }
  }
}

// the Button class
class Button {
  
  float x=ws/2-50;      // top left corner x position
  float y=ws/2-50;      // top left corner y position
  float w=50;      // width of button
  float h=50;      // height of button
  
  // constructor
  Button() {
    
  }
  
  void Draw() {
    fill(218);
    fill(255);
    triangle(ws/2-50, ws/2+50, ws/2-50, ws/2-50, ws/2+50, ws/2); 
  }
  
  boolean MouseIsOver() {
    if (mouseX > x && mouseX < (x + w) && mouseY > y && mouseY < (y + h)) {
      return true;
    }
    return false;
  }
}