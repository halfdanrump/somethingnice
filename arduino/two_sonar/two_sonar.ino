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
  float distance = sonar_measure_distance(A0);
  if (distance > 0) {
    Reading dist = {"distance", distance, millis()};
    add_to_tx_buf((char*)tx_buf, &dist);
  }

  distance = sonar_measure_distance(A1);
  if (distance > 0) {
    Reading dist = {"distance", distance, millis()};
    add_to_tx_buf((char*)tx_buf, &dist);
  }
  
  //Send data stored on "tx_buf" to collector
  chibiTx(AGGREGATOR_SHORT_ADDRESS, tx_buf, TX_LENGTH);

  // Debug print
  Serial.println((char*) tx_buf);

  free(tx_buf);
  //Wait
  delay(1000);
}

float sonar_measure_distance(int pin){
  int checkTimes = 10;
  long duration, cm;

  // read sensor data and send average data
  int sum = 0;
  for (int i=0; i<checkTimes; i++){
    delay(10);
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
    if(VERBOSE == 1){ 
      Serial.print(i);
      Serial.print(cm, 1);
      Serial.print("cm");
      Serial.println();
    }
    
    sum += cm;
  }
  float average = sum/(float)checkTimes;
  if(VERBOSE == 1){
    Serial.print("Average: ");
    Serial.println(average, 1);
    Serial.println();
  }
  return average;
}

long microsecondsToCentimeters(long microseconds)
{
  // The speed of sound is 340 m/s or 29 microseconds per centimeter.
  // The ping travels out and back, so to find the distance of the
  // object we take half of the distance travelled.
  return microseconds / 29 / 2;
}


