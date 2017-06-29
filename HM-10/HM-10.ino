
#include <SoftwareSerial.h>

SoftwareSerial BTSerial(11, 10); //RX|TX

int buttonPin = 7;
int buttonState = 0;
bool clicked = false;

String hello;
void setup() {
  Serial.begin(9600);
  BTSerial.begin(9600); // default baud rate
  while (!Serial); //if it is an Arduino Micro

  pinMode(buttonPin, INPUT);
  pinMode(13, OUTPUT);

}

void loop() {
  buttonState = digitalRead(buttonPin);

  if (buttonState == HIGH && clicked = false) {
    //Send Message and turn LED ON
    digitalWrite(13, HIGH);
    BTSerial.write("I Really Like Pie");
    clicked = true;
  } else if (buttonState == LOW) {
    digitalWrite(13, LOW);
    clicked = false;
  }


  //read from the HM-10 and print in the Serial
  if (BTSerial.available()) {
    Serial.write(BTSerial.read());
    if (Serial.available()) {
      Serial.print("Meow");
    }
  }
  delay(10);

}


