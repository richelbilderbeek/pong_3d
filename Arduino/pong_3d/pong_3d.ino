void setup() 
{
  pinMode(A0, INPUT);
  pinMode(A1, INPUT);
  Serial.begin(9600);
}

void loop() 
{
  Serial.write(0);
  Serial.write(analogRead(A0) / 4);
  Serial.write(analogRead(A1) / 4);
  Serial.write(255);
  delay(10);
}

