# Raspberry-Pi-Installer-Scripts

Some scripts for helping install Adafruit HATs, bonnets, add-on's, & friends!

Based heavily on get.pimoroni.com scripts!

* Install i2s amplifier with: `curl -sS https://raw.githubusercontent.com/adafruit/Raspberry-Pi-Installer-Scripts/master/i2samp.sh | bash`

## PDM microphone input

### Connections

| PDM mic pin | PDM mic signal| Raspberry Pi pin |RPI BCM | RPi function pin|
|--|--|--|--|--|
|1|VDD|pin 1| 3v3|Power|
|2|Data|pin 38 |BCM 20|MOSI|
|3|Clock|pin 12 |BCM 18|PWM0|
|4|Select: solder either to GND or VDD (L/R)|-|-|-|
| back side|GND|pin 6| GND |GND|

### installation

```bash
wget https://raw.githubusercontent.com/imec-int/Raspberry-Pi-Installer-Scripts/master/pdm_mic.sh
sudo chmod 755 pdm_mic.sh
./pdm_mic.sh
```

### TODO

right now the bit clock is not altered and going at 1.4MHz. By not having it at 3.072Meg we lose about 3dB of SNR. Rising the clock also changes sound frequency, so I need to take a deeper look into the linux bcm2835-i2s driver to see the connection between bclk and samplerate Fs?