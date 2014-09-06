#define GASPIN 11

float maxGas = 1.5;
float minGas = 0.1;
void setup() {
  Serial.begin(9600);
  init_gas_sensor();
//  analogWrite(6, 255);
}
 
 
void init_gas_sensor(){
  pinMode(GASPIN, OUTPUT);
}

float read_gas_sensor() {
  float gas;
  int sensorValue = analogRead(A0);
  gas=(float) sensorValue/1024*5.0;
  float scaledGas = (gas - minGas) / maxGas;
  scaledGas = max(scaledGas, 0) * 255;
  return scaledGas;
  
}

void loop(){
  float gaslevel = read_gas_sensor();
  analogWrite(GASPIN, gaslevel);
  Serial.print(gaslevel);
}


