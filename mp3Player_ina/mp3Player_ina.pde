//meco Aufgabe 1 Marco Agovino, Davina , Ina Widmer, Michael Job

import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.*;

AudioPlayer player;
AudioMetaData meta;
Minim minim;//audio context
FFT         fft;
PImage img;

int ws = 400;  //windowsize
String file ="";

Button on_button;  // the button
int clk = 1;       // number of times the button is clicked
boolean isPlaying = false;

void setup() {
  size (400, 400);
  minim = new Minim(this);  
  smooth();
  img = loadImage("musical-note.png");
 
  surface.setTitle("The Player");
  // create the button object
  on_button = new Button();
}

void fileSelected(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    file =  selection.getAbsolutePath();
    draw();
    println("User selected " + selection.getAbsolutePath());
  }
}

void draw() {

    background(0);
    fill(255);
    
    if(file==""){
       image(img, ws/2-70,ws/2-70);
    }else{
      if(!isPlaying){
       triangle(ws/2-50, ws/2+50, ws/2-50, ws/2-50, ws/2+50, ws/2); 
      } else {
        textSize(20);
        text(meta.title() +" - "+meta.author(), 5, 25);
        rect(ws/2-50,ws/2-50, 30, 100);
        rect(ws/2+10,ws/2-50, 30, 100);
        
        stroke(255); 
        // perform a forward FFT on the samples in jingle's mix buffer,
        // which contains the mix of both the left and right channels of the file
        fft.forward( player.mix );
        
        for(int i = 0; i < fft.specSize(); i++)
        {
          // draw the line for frequency band i, scaling it up a bit so we can see it
          line( i, height, i, height - fft.getBand(i)*8 );
        }        
        
      }
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
   if(file==""){
      selectInput("Select a file to process:", "fileSelected");
   }else{
      if(!isPlaying) {
          play();
      }
      else {
          pause();
      }
   }
   draw();
  }
}

void play(){
     isPlaying=true;
     player = minim.loadFile(file, 2048);
     fft = new FFT( player.bufferSize(), player.sampleRate() );
     meta = player.getMetaData();
     player.play();
}

void pause(){
      isPlaying=false;
      player.close();
      minim.stop(); 
}

// the Button class
class Button {
  
  float x=ws/2-50;      // top left corner x position
  float y=ws/2-50;      // top left corner y position
  float w=200;      // width of button
  float h=200;      // height of button
  
  // constructor
  Button() {
    
  }  
  
  
  boolean MouseIsOver() {
    if (mouseX > x && mouseX < (x + w) && mouseY > y && mouseY < (y + h)) {
      return true;
    }
    return false;
  }
}