import processing.opengl.*;
import ddf.minim.*;

import arb.soundcipher.*;        // simple audio library "SoundCipher"  (tempo=120 bpm) 


AudioPlayer player;
Minim minim;//audio context
import processing.serial.*;
int num = 120;
float[][] fire = new float [num][12];
int sensor0 = 0;
int sensor1 = 0;
 
Serial myPort;
 
void setup() {
  size(1200, 800, OPENGL);
  background(51);
SoundCipher sc = new SoundCipher(this);   // sound object for audio feedback 
sc.playNote(60, 100, 1); // pitch number, volume, duration in beats 
sc.playNote(100, 100, 1); // pitch number, volume, duration in beats 
sc.playNote(140, 100, 1); // pitch number, volume, duration in beats 
sc.playNote(180, 100, 2); // pitch number, volume, duration in beats 
sc.playNote(60, 100, 6); // pitch number, volume, duration in beats 

  frameRate(120);
  hint(ENABLE_OPENGL_4X_SMOOTH);
  rectMode(CENTER);
  smooth();
  noStroke();
  minim = new Minim(this);
  player = minim.loadFile("fire.mp3", 2048); //soundjay
  player.play();
  // List all the available serial ports
  println(Serial.list());
  // I know that the first port in the serial list on my mac
  // is always my  Arduino, so I open Serial.list()[0].
  // Open whatever port is the one you're using.
  myPort = new Serial(this, Serial.list()[0], 9600);
  // don't generate a serialEvent() unless you get a newline character:
  myPort.bufferUntil('\n');
}
 
void draw() {
  // do your stuff here!
  create_fire();
  update_fire(); 
  draw_fire();
  //background(0);
}
 
void serialEvent(Serial myPort) {
  // get the ASCII string:
  String inString = myPort.readStringUntil('\n');
 
  if (inString != null) {
    // trim off any whitespace:
    inString = trim(inString);
    // split the string on the commas and convert the
    // resulting substrings into an integer array:
    int[] sensors = int(split(inString, ","));
    // if the array has at least two elements, you know
    // you got the whole thing.  Put the numbers in the
    // sensor variables:
    if (sensors.length >=2) {
      sensor0 = sensors[0];
      sensor1 = sensors[1];
    }
  }
}

void update_fire()
  {
  for(int flame=0 ; flame<num ; flame++)
  {
    if(fire[flame][0]==1)
    {
	fire[flame][1]=fire[flame][1]+fire[flame][5]*cos(fire[flame][3]);
	fire[flame][2]=fire[flame][2]+fire[flame][5]*sin(fire[flame][3]);
    }
    fire[flame][7]+=1;
    if(fire[flame][7]>fire[flame][6]){
	fire[flame][0]=0;
    }
  }
}
void draw_fire(){
  for(int flame=0 ; flame<num ; flame++){
    if(fire[flame][0]==1){
	fill(fire[flame][9],fire[flame][10],0,40);
	pushMatrix();
	translate(fire[flame][1],fire[flame][2]);
	rotate(fire[flame][8]);
	rect(0,0,fire[flame][4],fire[flame][4]);
	popMatrix();
    }
  }
}
void create_fire()
{
    for(int i=num-1; i>0; i--)
    {
	for(int fireprop=0;fireprop<11;fireprop++)
	{
	  fire[i][fireprop]=fire[i-1][fireprop];
	}
    
      fire[0][0]=1;
      fire[0][1]=600;
      fire[0][2]=400;
      fire[0][3]=random(0,PI*2);//angle
      fire[0][4]=random(5,sensor0/5);//size
      fire[0][5]=random(1,2);//speed
      fire[0][6]=random(10,sensor0/3);//maxlife
      fire[0][7]=0;//currentlife
      fire[0][8]=random(0,TWO_PI);
      fire[0][9]=random(200,sensor0);//red
      fire[0][10]=random(50,sensor0);//green
   }
 }  

void stop()
{
  player.close();
  minim.stop();
  super.stop();
}
