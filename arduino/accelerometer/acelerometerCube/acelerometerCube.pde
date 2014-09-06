import processing.serial.*;
 
float sensor0 = 0;
float sensor1 = 0;
 
Serial myPort;
 
void setup() {
  size(640, 360, P3D);
  noStroke();
  fill(204);
 
  // List all the available serial ports
  println(Serial.list());
  // I know that the first port in the serial list on my mac
  // is always my  Arduino, so I open Serial.list()[0].
  // Open whatever port is the one you're using.
  myPort = new Serial(this, Serial.list()[0], 9600);
  // don't generate a serialEvent() unless you get a newline character:
  myPort.bufferUntil('\n');
}

void draw()  {
  background(0);
  lights();

//  print(sensor0);
//  print(", ");
//  println(sensor1);
  if(mousePressed) {
    float fov = PI/3.0; 
    float cameraZ = (height/2.0) / tan(fov/2.0); 
    perspective(fov, float(width)/float(height), cameraZ/2.0, cameraZ*2.0); 
  } else {
    ortho(0, width, 0, height); 
  }
  translate(width/2, height/2, 0);
  rotateX(sensor0*3.141592/180); 
  rotateY(sensor1*3.141592/180); 
  
  int x=100;
  
    // Front
  beginShape(QUADS);
  fill(255,0,0);
  vertex(-x, -x, x);
  vertex(x, -x, x);
  vertex(x, x, x);
  vertex(-x, x, x);
  endShape();
  // Back
  beginShape(QUADS);
  fill(255,255,0);
  vertex(x, -x, -x);
  vertex(-x, -x, -x);
  vertex(-x, x, -x);
  vertex(x, x, -x);
  endShape();
  // Bottom
  beginShape(QUADS);
  fill( 255,0,255);
  vertex(-x, x, x);
  vertex(x, x, x);
  vertex(x, x, -x);
  vertex(-x, x, -x);
  endShape();
  // Top
  beginShape(QUADS);
  fill(0,255,0);
  vertex(-x, -x, -x);
  vertex(x, -x, -x);
  vertex(x, -x, x);
  vertex(-x, -x, x);
  endShape();
  // Right
  beginShape(QUADS);
  fill(0,0,255);
  vertex(x, -x, x);
  vertex(x, -x, -x);
  vertex(x, x, -x);
  vertex(x, x, x);
  endShape();
  // Left
  beginShape(QUADS);
  fill(0,255,255);
  vertex(-x, -x, -x);
  vertex(-x, -x, x);
  vertex(-x, x, x);
  vertex(-x, x, -x);
  endShape();
  
  
  // box(160); 
}
 
void serialEvent(Serial myPort) {
  // get the ASCII string:
  String inString = myPort.readStringUntil('\n');
 
  if (inString != null) {
    // trim off any whitespace:
    inString = trim(inString);
    // split the string on the commas and convert the
    // resulting substrings into an integer array:
    float[] sensors = float(split(inString, ","));
    // println(sensors);
    // if the array has at least two elements, you know
    // you got the whole thing.  Put the numbers in the
    // sensor variables:
    if (sensors.length >=2) {
      sensor0 = sensors[0];
      sensor1 = sensors[1];
    }
  }
}
