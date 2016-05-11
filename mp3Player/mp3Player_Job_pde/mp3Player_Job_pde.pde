//meco Aufgabe 1 Marco Agovino, Davina , Ina Widmer, Michael Job

import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.*;
import processing.awt.PSurfaceAWT.SmoothCanvas;
import javax.swing.JFrame;
import java.awt.Dimension;

AudioPlayer player;
AudioMetaData meta;
Minim minim;//audio context
FFT         fft;
PImage img;

int ws = 300;  //windowsize
int min = 200;
int max = 800;

String file ="";

Button on_button;  // the button
boolean isPlaying = false;
float volume = -30;

void setup() {
  size (500, 500);  //here it must be numbers not variables

  SmoothCanvas sc = (SmoothCanvas) getSurface().getNative();
  JFrame jf = (JFrame) sc.getFrame();
  Dimension d = new Dimension(min, min);
  jf.setMinimumSize(d);
 // println(jf.getMinimumSize());
  getSurface().setResizable(true);
  
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
//    println("Window was closed or the user hit cancel.");
  } else {
    file =  selection.getAbsolutePath();
    draw();
//    println("User selected " + selection.getAbsolutePath());
  }
}

void draw() {
    Dimension quadrat = new Dimension(height, height);
    frame.setSize(quadrat);
    //ws=height;  man könnte nun untenstehend alle width height durch ws erstetzen...
    background(0);
    fill(255);
    
     on_button.resizeButton();
    
    if(file==""){
      //draw note
       image(img, width/2-70,height/2-70);
    }else{
      if(!isPlaying){
        //draw play button
         stroke(255);
       triangle(width/2-50, height/2+50, width/2-50, height/2-50, width/2+50, height/2); 
      } else {
        
       //set volume trough window size (min=200 max=800 of window; gain range from -60 to 18 ; map range 0-78 to window 0 to 600 px
       float gainNew = (((width-200)*78)/600)-60;
       player.setGain(gainNew); 
       
        //draw cover
      //  byte[] img = meta.cover();
        
        //draw artist and songtitle
        textSize(20);
        text(meta.title() +" - "+meta.author(), 5, 25);
        //draw pause-symbol
         stroke(255);
        rect(width/2-50,height/2-50, 30, 100);
        rect(width/2+10,height/2-50, 30, 100);
        
       
        // perform a forward FFT on the samples in jingle's mix buffer,
        // which contains the mix of both the left and right channels of the file
        fft.forward( player.mix );
        //draw frequencies
        strokeWeight((width/fft.specSize())+2); 
        for(float i = 0; i < fft.specSize(); i=i+5) {    //i in float for color calculation  
          stroke( (i/512)*255 , 0 , abs( (i/512*255)-255 )   );
          // draw the line for frequency band i, scaling it up a bit so we can see it
          line( i, height, i, height - fft.getBand((int)i)*12 );    //i cast to int for FFT
          stroke( abs( (i/512*255)-255 ),0, (i/512)*255  );
          // draw the line for frequency band i, scaling it up a bit so we can see it
          line( width-i, 0, width-i, fft.getBand((int)i)*12 );    //i cast to int for FFT
      
        }    
      }
    }
}

// mouse button clicked
void mouseReleased()
{
  if (on_button.MouseIsOver()) {
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
     player = minim.loadFile(file, 1024);
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