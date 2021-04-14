#!/bin/bash

echo "This script downloads and installs PDM microphone support."
# check the raspberry pi version:
device=$( cat /proc/device-tree/model )
echo "found: $device"
if [[ $device != *"Raspberry"* ]]; then
  echo "device is not recognized as a raspberry pi"
  exit 1
fi
if [[ $device != *"Pi[[:space:]]4"* ]]; then
  pimodel=2
elif [[ $device != *"Pi[[:space:]]3"* ]]; then
  echo "raspberry pis lower than a 4 haven't been tested yet"
  pimodel=1
elif [[ $device != *"Pi[[:space:]]2"* ]]; then
  echo "raspberry pis lower than a 4 haven't been tested yet"
  pimodel=1
else
  echo "raspberry pis lower than a 4 haven't been tested yet"
  pimodel=0
fi

read -p "Do you wish to load the driver automatically? (yes/no) " yn
case $yn in
        [Yy]* ) autoload=true;;
        [Nn]* ) autoload=false;;
        * ) echo "Please answer yes or no.";;
esac

sudo apt-get -y install git raspberrypi-kernel-headers

# change to home directory to check for git installations
cd

if [ ! -d "Raspberry-Pi-Installer-Scripts" ]; then
    echo "cloning the RPI installer scripts"
    git clone https://github.com/imec-int/Raspberry-Pi-Installer-Scripts
else
    echo "update rpi installer scripts"
    cd Raspberry-Pi-Installer-Scripts
    git pull
    cd
fi

# adapt the linux bcm2835_i2s kernel driver to enable pdm
echo "adapting the linux kernel driver bcm2835-i2s for pdm operation"
echo ""
cd Raspberry-Pi-Installer-Scripts/pdm_mic_module/linux_bcm2835_kernel
make -C /lib/modules/$(uname -r )/build M=$(pwd) modules
# make a copy of the original file
sudo cp /lib/modules/$(uname -r )/kernel/sound/soc/bcm/snd-soc-bcm2835-i2s.ko /lib/modules/$(uname -r )/kernel/sound/soc/bcm/snd-soc-bcm2835-i2s.BAK 
# copy the new kernel module
sudo cp snd-soc-bcm2835-i2s.ko /lib/modules/$(uname -r )/kernel/sound/soc/bcm/snd-soc-bcm2835-i2s.ko
cd

# Build and install the module
echo "building the kernel module for the soundcard"
echo ""
cd Raspberry-Pi-Installer-Scripts/pdm_mic_module/pdm_soundcard
make clean
make
sudo make install

# Setup auto load at boot if selected, notice, we can't use "sudo echo" to have elevated rights to write to the module files
if [[ $autoload = true ]] ; then
  echo "snd-i2smic-rpi" | sudo tee -a /etc/modules-load.d/snd-pdmmic-rpi.conf
  echo "options snd-i2smic-rpi rpi_platform_generation=$pimodel" | sudo tee -a /etc/modprobe.d/snd-pdmmic-rpi.conf
fi

# enable I2S/PDM overlay in the device tree
sudo sed -i -e 's/#dtparam=i2s/dtparam=i2s/g' /boot/config.txt
echo ""
echo "Done installing, settings take effect on next boot"
echo ""
read -p "Do you wish to reboot? " yn
case $yn in
        [Yy]* ) sudo reboot;;
        [Nn]* ) echo "after the next boot you'll find the soundcard enabled";;
        * ) echo "Please answer yes or no.";;
esac