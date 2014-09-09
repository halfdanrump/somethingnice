
#include <math.h>
const int ledPin=9;
const int ledPin2=11;
const int ledPin3=10;

const int thresholdvalue=10; 
float Rsensor;

void setup() {
  Serial.begin(9600);
  pinMode(ledPin,OUTPUT);
  pinMode(ledPin2,OUTPUT);
  pinMode(ledPin3,OUTPUT);
}

void loop() {
  int sensorValue = analogRead(0); 
  Rsensor=(float)(1023-sensorValue)*10/sensorValue;

  analogWrite(ledPin,(sensorValue % 255));
  analogWrite(ledPin2,(sensorValue % 255));
  analogWrite(ledPin3,(sensorValue % 255));

  Serial.println("the analog read data is ");
  Serial.println(sensorValue);
  Serial.println("the sensor resistance is ");
  Serial.println(Rsensor,DEC);
  delay(1000);
}
