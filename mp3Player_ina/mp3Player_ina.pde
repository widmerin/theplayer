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
int min = 200;
int max = 800;

String file ="";

Button on_button;  // the button
int clk = 1;       // number of times the button is clicked
boolean isPlaying = false;
float volume = -30;

void setup() {
  size (400, 400);
  minim = new Minim(this);  
  smooth();
  surface.setResizable(true);
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
    
     on_button.resizeButton();
    
    if(file==""){
       image(img, ws/2-70,ws/2-70);
    }else{
      if(!isPlaying){
       triangle(width/2-50, height/2+50, width/2-50, height/2-50, width/2+50, height/2); 
      } else {
        
       //set volume trough window size
      if( width <= min && height <= min){
        player.setGain(-60);
      } else if (width >=max && height >= max){
          player.setGain(18);
      } else{
        player.setGain(volume);
      }        
        
        //draw pause-symbol
        textSize(20);
        text(meta.title() +" - "+meta.author(), 5, 25);
        rect(width/2-50,height/2-50, 30, 100);
        rect(width/2+10,height/2-50, 30, 100);
        
        //draw frequencies
        stroke(255); 
        // perform a forward FFT on the samples in jingle's mix buffer,
        // which contains the mix of both the left and right channels of the file
        fft.forward( player.mix );
        
        for(int i = 0; i < fft.specSize(); i++)
        {
          // draw the line for frequency band i, scaling it up a bit so we can see it
          line( i, height, i, height - fft.getBand(i)*16 );
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
  
  float x=50;      // top left corner x position
  float y=50;      // top left corner y position
  float w=width-100;      // width of button
  float h=height-100;      // height of button
  
  // constructor
  Button() {
    
  }  
  
  
  boolean MouseIsOver() {
    if (mouseX > x && mouseX < (x + w) && mouseY > y && mouseY < (y + h)) {
      return true;
    }
    return false;
  }
  
   void resizeButton(){
    on_button = new Button();
  }
}