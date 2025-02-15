+++
title = "ELEGOO Uno R3 Notes"
date = 2025-02-09T18:25:29Z
+++

I've been farting around with an ELEGOO [Uno R3](https://docs.arduino.cc/hardware/uno-rev3/)
(that came as part of their [Basic Starter Kit](https://www.elegoo.com/en-gb/blogs/arduino-projects/elegoo-uno-project-basic-starter-kit-tutorial)),
today. I think it's a pretty old-hat device at this point, but I thought I'd
put some notes here, mainly for my future self, but also in case anybody else
might find them useful.

## Documentation

The tutorials and documentation distributed by ELEGOO is quite old at this
point, and not very well written or presented. Fortunately, there isn't much
need to use it, as the device seems to be exactly the same as the
[Adafruit Uno R3](https://www.adafruit.com/product/4806), so all of their
[Uno R3 documentation](https://learn.adafruit.com/lesson-0-getting-started)
should apply. No need to run any of their software either; just download the
latest version of [Arduino IDE](https://www.arduino.cc/en/software) and it
should work out-of-the-box. If you're using Windows, it's probably best to
install Arduino IDE before connecting the Uno to your PC because Arduino IDE
installs a bunch of drivers that you'll need for it to work.

## 2.8" TFT Touch Shield for Arduino

I also have an [ELEGOO 2.8 Inch Touch Screen for Arduino UNO](https://www.elegoo.com/en-gb/blogs/arduino-projects/elegoo-2-8-inch-touch-screen-for-raspberry-pi-manual).
Similar to the Uno R3 itself, this seems to be more-or-less the same as the
[Adafruit 2.8" TFT Touch Shield for Arduino](https://www.adafruit.com/product/376).
Again, you can ignore the ropey ELEGOO documentation and software and just use
[the Adafruit stuff](https://learn.adafruit.com/2-8-tft-touch-shield).

Important things to know to get the touchscreen working:

 - You'll need to install the [Adafruit_TFTLCD](https://github.com/adafruit/TFTLCD-Library)
 library in Arduino IDE to get up and running. Arduino IDE should take care of
 installing the [Adafruit GFX Library](https://github.com/adafruit/Adafruit-GFX-Library)
 dependency.
 - Use Arduino IDE to install [Adafruit TouchScreen Library](https://github.com/adafruit/Adafruit_TouchScreen).
 I haven't messed around with this yet, but I assume you'll need it for the
 touchscreen functions of the display.
 - **Do not** set/uncomment the `USE_ADAFRUIT_SHIELD_PINOUT` in
 Adafruit_TFTLCD.h! I know the documention says to if you're using the shield
 version, and this is the shield version, but doing so means any code that uses
 the GFX library generates a white screen. [Here's someone else who had the same issue](https://forum.arduino.cc/t/elegoo-2-8-tft-touch-screen-w-micro-sd-card-usage-uno-vs-mega2560/1089162).
