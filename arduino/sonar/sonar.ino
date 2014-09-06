#include <config.h>
#include <utilsawesome.h>

/*
Freakduino Chibi-9000

Collects data from different sensors and sends it to 
the aggregator as defined in "config.h"
*/

#include <chibi.h>

/**************************************************************************/
// Initialize
/**************************************************************************/
void setup()
{
  // Initialize the chibi command line and set the speed to 57600 bps
  chibiCmdInit(57600);
  
  // Initialize the chibi wireless stack
  chibiInit();

//  Serial.println("Type,\tstatus,\tHumidity (%),\tTemperature (C)");
}

/**************************************************************************/
// Loop
/**************************************************************************/
void loop()
{

  byte tx_buf[TX_LENGTH];
  memset(tx_buf, 0, TX_LENGTH);
  long duration, inches, cm;
  
  // Read sonar distance
  int distance1 = (int) (sonar_measure_distance(A0) * 15);
  if (distance1 > 0) {
    Reading dist1 = {"distance1", distance1, millis()};
    add_to_tx_buf((char*)tx_buf, &dist1);
  }

  int distance2 = (int) (sonar_measure_distance(A1) * 15);
  if (distance2 > 0) {
    Reading dist2 = {"distance2", distance2, millis()};
    add_to_tx_buf((char*)tx_buf, &dist2);
  }
  
  //Send data stored on "tx_buf" to collector
  chibiTx(AGGREGATOR_SHORT_ADDRESS, tx_buf, TX_LENGTH);

  // Debug print
  Serial.print(distance1);
  Serial.print(",");
  Serial.println(distance2);

  free(tx_buf);
  //Wait
  delay(10);
}

float sonar_measure_distance(int pin){
  int checkTimes = 10;
  long duration, cm;

  // read sensor data and send average data
  int sum = 0;
  for (int i=0; i<checkTimes; i++){
    delay(1);
    // The PING))) is triggered by a HIGH pulse of 2 or more microseconds.
    // Give a short LOW pulse beforehand to ensure a clean HIGH pulse:
    pinMode(pin, OUTPUT);
    digitalWrite(pin, LOW);
    delayMicroseconds(2);
    digitalWrite(pin, HIGH);
    delayMicroseconds(5);
    digitalWrite(pin, LOW);
  
    // The same pin is used to read the signal from the PING))): a HIGH
    // pulse whose duration is the time (in microseconds) from the sending
    // of the ping to the reception of its echo off of an object.
    pinMode(pin, INPUT);
    duration = pulseIn(pin, HIGH);
  
    // convert the time into a distance
    cm = microsecondsToCentimeters(duration);    
    sum += cm;
  }
  float average = sum/(float)checkTimes;
  return average;
}

long microsecondsToCentimeters(long microseconds)
{
  // The speed of sound is 340 m/s or 29 microseconds per centimeter.
  // The ping travels out and back, so to find the distance of the
  // object we take half of the distance travelled.
  return microseconds / 29 / 2;
}


