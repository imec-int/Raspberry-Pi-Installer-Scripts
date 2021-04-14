# Raspberry-Pi-Installer-Scripts

Some scripts for helping install Adafruit HATs, bonnets, add-on's, & friends!

Based heavily on get.pimoroni.com scripts!

  * Install i2s amplifier with: curl -sS https://raw.githubusercontent.com/adafruit/Raspberry-Pi-Installer-Scripts/master/i2samp.sh | bash

## PDM microphone input

### Connections

| PDM mic pin | PDM mic signal|Raspberry Pi pin|
|--|--|--|
|1|VDD||
|2|Data||
|3|Clock||
|4|Select||
| back side|GND|GND|

### installation

```bash
wget https://raw.githubusercontent.com/imec-int/Raspberry-Pi-Installer-Scripts/master/pdm_mic.sh
sudo chmod 755 pdm_mic.sh
./pdm_mic.sh
```
