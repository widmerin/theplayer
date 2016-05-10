//meco Aufgabe 1 Marco Agovino, Davina , Ina Widmer, Michael Job
import ddf.minim.analysis.*;
import ddf.minim.*;

AudioPlayer player;
Minim minim;//audio context
FFT         fft;
int ws = 200;  //windowsize


Button on_button;  // the button
int clk = 1;       // number of times the button is clicked
boolean isPlaying = false;

void setup() {
  size (512, 200, P3D);
  minim = new Minim(this);  
  smooth();   // für was ist das?
  
  // create the button object
  on_button = new Button(); 
}

void draw() {
  // draw a square if the mouse curser is over the button
  background(0); 
  
  // draw the button in the window
   on_button.Draw();
}

void drawFreq() {
  // draw a square if the mouse curser is over the button
  background(0);
   stroke(255);
  //Visualise:**************
  // perform a forward FFT on the samples in jingle's mix buffer,
  // which contains the mix of both the left and right channels of the file
  fft.forward(player.mix);
  
  for(int i = 0; i < fft.specSize(); i++)
  {
    // draw the line for frequency band i, scaling it up a bit so we can see it
    line( i, ws, i, ws - fft.getBand(i)*12 );
  }  
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
      player = minim.loadFile("alice.mp3", 2048);
        player.loop();
        drawFreq();
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