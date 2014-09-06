int sensorValue0;
 
void setup() {
  // initialize the serial communication:
  Serial.begin(9600);
}
 
void loop() {
  sensorValue0 = analogRead(A0);
  Serial.print(sensorValue0);
  delay(10);
}
