
import processing.serial.*;
 
int sensor0 = 0;
int sensor1 = 0;
 
Serial myPort;
 
void setup() {
  size(900,900);
  
  // List all the available serial ports
  println(Serial.list());
  // I know that the first port in the serial list on my mac
  // is always my  Arduino, so I open Serial.list()[0].
  // Open whatever port is the one you're using.
  myPort = new Serial(this, Serial.list()[5], 57600);
  
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
}
 
void serialEvent(Serial myPort) {
  // get the ASCII string:
  String inString = myPort.readStringUntil('\n');
 
  if (inString != null) {
    // trim off any whitespace:
    inString = trim(inString);
    println(inString);
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
