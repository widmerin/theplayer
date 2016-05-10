
import ddf.minim.*;
import ddf.minim.ugens.*;

AudioPlayer player;
Gain gain;
Minim minim;//audio context

Button on_button;  // the button
Button plus_button;  // to add a new window
int clk = 1;       // number of times the button is clicked
int min = 200;
int max = 800;
boolean isPlaying = false;
boolean resizing = false;
float volume = -30;

void setup() {
  size (400, 400);
  minim = new Minim(this);  
  smooth();
  surface.setResizable(true);
  
  // create the button object
  on_button = new Button("Play", 50, 50, 300, 300);

}

void draw() {
  smooth();
  // show hidden buttons (delte window, new window, resize for volume) when mouse curser is over the button
  if (on_button.MouseIsOver() ) {
    // alle buttons müssen angezeigt werden
    fill(255);
    rect(350, 350, 50, 50);
  }
  else {
    // hide the square if the mouse cursor is not over the button
    background(0);
  }
  // draw the button in the window
  on_button.Draw();

  if (resizing) {

  } else {
      on_button.resizeButton();
  }

  if (isPlaying){
    if( width <= min && height <= min){
        player.setGain(-60);
    } else if (width >=max && height >= max){
        player.setGain(18);
    } else{
      player.setGain(volume);
    }
  }

}

  
// Drag (click and hold) your mouse 
void mouseDragged() 
{
  resizing = true;
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
      on_button.setTitle("Stop");
      player = minim.loadFile("besser.mp3", 2048);
      player.play();
    }
    else {
      on_button.setTitle("Play");
      isPlaying=false;
      player.close();
      minim.stop();
    }
  }

}

// the Button class
class Button {
  String label; // button label
  float x;      // top left corner x position
  float y;      // top left corner y position
  float w;      // width of button
  float h;      // height of button
  
  // constructor
  Button(String labelB, float xpos, float ypos, float widthB, float heightB) {
    label = labelB;
    x = xpos;
    y = ypos;
    w = widthB;
    h = heightB;
  }
  
  void Draw() {
    fill(67);
    //stroke(141);
    rect(x, y, w, h, 0);
    textAlign(CENTER, CENTER);
    fill(0);
    text(label, x + (w / 2), y + (h / 2));
  }
  
  void setTitle(String titleText) {
    label = titleText;
  }
  
  boolean MouseIsOver() {
    if (mouseX > x && mouseX < (x + w) && mouseY > y && mouseY < (y + h)) {
      return true;
    }
    return false;
  }
  
  void resizeButton(){
    on_button = new Button("Play", 50, 50, width-100, height-100);
  }
}