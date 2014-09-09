
import processing.serial.*;
 
int sensor0 = 0;
int sensor1 = 0;
 
Serial myPort;
 
 
 import javax.sound.midi.*;
 
Synthesizer synthesizer = null;
 
boolean StartSynth()
{
  try
  {
    synthesizer = MidiSystem.getSynthesizer();
    synthesizer.open();
  }
  catch (MidiUnavailableException e)
  {
    println("Cannot play!");
    return false;
  }
  return true;
}
void StopSynth()
{
  if (synthesizer != null)
  {
    synthesizer.close();
    synthesizer = null;
  }
}
void Wait(int duration)
{
  try { Thread.sleep(duration); } catch (InterruptedException e) {}
}
void PlayNote(int noteNumber, int velocity, int duration)
{
  MidiChannel[] channels = synthesizer.getChannels();
  channels[0].noteOn(noteNumber, velocity);
  Wait(duration);
  channels[0].noteOff(noteNumber);
}
void PlayNote(int noteNumber, int velocity, int durationOn, int durationOff)
{
  MidiChannel[] channels = synthesizer.getChannels();
  channels[0].noteOn(noteNumber, velocity);
  Wait(durationOn);
  channels[0].noteOff(noteNumber, durationOff);
}

void stop()
{
  println("Stop");
  StopSynth();
  super.stop();
}


 
void setup() {
  size(900,900);
  
  // List all the available serial ports
  println(Serial.list());
  // I know that the first port in the serial list on my mac
  // is always my  Arduino, so I open Serial.list()[0].
  // Open whatever port is the one you're using.
  myPort = new Serial(this, Serial.list()[0], 57600);
  
//    if (!StartSynth())
//  {
//    exit();
//  } 
//  PlayNote(72, 120, 500);
//  PlayNote(60, 80, 200);
//  PlayNote(68, 80, 300);
//  Wait(200);
//  PlayNote(48, 60, 500, 800);
//  Wait(500);
// 
//  exit(); 
  
}
 
void draw() {
  // do your stuff here!
  fill(255,0,0);
  background(0);
  ellipse(width/2, height/2, sensor0, sensor1);
  serialEvent(myPort);
//  print(sensor0);
//  print(",");
//  print(sensor1);

    if (!StartSynth())
  {
    exit();
  } 
  int tone; 
  //= (int)(log(sensor0)/log(2));
// print(tone); 
  if (sensor0 < 110)
//  tone = (int)(sensor0 * 33 / 100);
//  else if (sensor0 >= 110 && sensor0 < 210)
//  tone = (int)(sensor0 * 33 / 100)*2;
//  else if (sensor0 >= 210 && sensor0 < 310)
//  tone = (int)(sensor0 * 33 / 100)*3;
//  else if (sensor0 >= 310 && sensor0 < 410)
//  tone = (int)(sensor0 * 33 / 100)*4;
//  else if (sensor0 >= 410 && sensor0 < 510)
//  tone = (int)(sensor0 * 33 / 100)*5;
//  else if (sensor0 >= 510 && sensor0 < 610)
//  tone = (int)(sensor0 * 33 / 100)*6;
//  else if (sensor0 >= 610 && sensor0 < 710)
//  tone = (int)(sensor0 * 33 / 100)*7;
//  else
//  tone = (int)(sensor0 * 33 / 100)*8;
// print(sensor0);
// print(",");
// println(tone);
  PlayNote(sensor0, sensor1, 100);
  //PlayNote(60, 80, 200);
  //PlayNote(68, 80, 300);
  //Wait(200);
  //PlayNote(48, 60, 500, 800);
  Wait(10);
 
  //exit(); 


}
 
void serialEvent(Serial myPort) {
  // get the ASCII string:
  String inString = myPort.readStringUntil('\n');
 
  if (inString != null) {
    // trim off any whitespace:
    inString = trim(inString);
    //println(inString);
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
