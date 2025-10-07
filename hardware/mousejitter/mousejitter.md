https://ericdraken.com/usb-mouse-jiggler/
https://forum.arduino.cc/t/how-to-use-digistump-digikeyboard-library-with-attinycore/1337388/6
Настройки:
![[settings.png]]

code
```
#include <DigiMouse.h>
void setup(){
  DigiMouse.begin();
  pinMode(1, OUTPUT);
}

void loop() {
  while(true) {
    digitalWrite(1, HIGH);
    DigiMouse.move(2,0,0); // 2px right
    DigiMouse.delay(50);
    DigiMouse.move(-2,0,0); // 2px left
    digitalWrite(1, LOW);
    DigiMouse.delay(random(280000, 320000));
  }
}
```

usbconfig.h
%LOCALAPPDATA%\Arduino15\packages\digistump\hardware\avr\1.7.5\libraries\DigisparkMouse\usbconfig.h