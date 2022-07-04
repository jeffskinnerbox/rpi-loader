<!--
Maintainer:   jeffskinnerbox@yahoo.com / www.jeffskinnerbox.me
Version:      0.1
-->


<div align="center">
<img src="http://www.foxbyrd.com/wp-content/uploads/2018/02/file-4.jpg" title="These materials require additional work and are not ready for general use." align="center">
</div>


---


# Test-Pi's Physical Design
I initial consider using `test-pi` to implement machine vision on a Raspberry Pi
with tools like OpenCV and TensorFlow.
These tools can be computationally very intensive, pushing the RPi CPU very hard,
causing the processor to generate considerable heat.
The RPi's processor must protect itself from high temperatures,
so when the processor’s internal temperature approaches 85 degrees Celsius,
it protects itself by disables overclocking,
reverting to minimal speeds/freq and voltages,
or in some cases shutting down completely.

I also what the `test-pi` to be physically portable,
so I could move it from my desk to some location to do its intended function.
This requires battery operation,
including the ability to turn this battery supply on/off gracefully
to avoid corrupting the software and operating system.

## Active Cooling
So the performance of the machine vision algorithm may be impacted by the heat of the RPi processor.
To combat this, it could be beneficial to provide active cooling.
Microsoft blog, "[Active cooling your Raspberry Pi 3][01]",
provides some data on how effective adding a fan can be.
(NOTE: You can fine the Raspberry Pi 3 Fan Mount [STL file][07] [here][02],
and have it 3D printed at [shapeways][06], [ProtoLab][08] or other sites.
To view the STL file, you can use [this site][05].

## Battery Supply + Power Monitoring
The [LiFePO4wered/Pi3][09] (purchase on [Tindie][11])
may be the best power solution for the Raspberry Pi 3.
It combines both the UPS and power monitoring functions into a single solution.
It also has PCB touch button that gives you clean shutdown instead of just pulling power.
A ultra-low power [MSP430G2231 microcontroller][10] monitors the battery
and also connected to the Pi's I2C bus and monitors the Pi's running state.
You can find more information in the [LiFePO4wered/Pi3 Product Brief][13].

The designer provides a [open source software package to interact with the LiFePO4wered/Pi3][12].
It contains an application development library,
a CLI interface to read/write device registers over the I2C bus,
and a tiny daemon (`lifepo4wered-daemon`) that continually tracks the power state.
The daemon can initiate a clean shutdown when the battery is empty
or the user wants to turn the RPi off using the touch button.
Touch button parameters, voltage thresholds,
and an auto boot flag can be customized by the user and saved to flash.
You can also set it up so the RPi will automatically boot whenever there is enough battery charge.
There is also a wake up timer that can be set so the Pi can shut down,
and automatically be started again after the wake timer expires.

The LiFePO4wered/Pi3 is specifically designed for the heavy load conditions
found on a typical Raspberry Pi 3 but can work on all the RPi versions.
(**NOTE:** The [LiFePO4wered/Pi][10] is smaller and engineered for the Raspberry Pi Zero.)
You can even get a case with room for the RPi3 and the LiFePO4wered/Pi3 [on Tindie][14].

The LiFePO4wered/Pi3 requires software to be running on the Raspberry Pi to operate correctly.
This software provides a daemon that automatically
manages the power state and shutdown of the RPi,
a library that allows integration of LiFePO4wered/Pi3 functionality in user programs,
and a CLI (command line interface) program that allows the user to
easily configure the LiFePO4wered/Pi3 or control it from shell scripts.

## Install
The [LiFePO4wered/Pi3 Product Brief][13] and the [GitHub site][12]
tells you how to load the software and is summarized below:

```bash
# login to the raspberry pi
ssh pi@192.168.1.79

# install the prerequisite software needed
sudo apt-get -y install build-essential git libsystemd-dev

# clone software package
mkdir src
cd ~/src
git clone https://github.com/xorbit/LiFePO4wered-Pi.git

# build the software
cd LiFePO4wered-Pi
make all

# install the software
sudo make user-install

# reboot to assure the enablement of I2C device
# we'll so we can change to battery power
sudo shutdown -h now
```

Now move the USB cable from the Raspberry Pi's power port to the
LiFePO4wered/Pi USB power port.
Touch the button to start the RPi.

```bash
# login to the raspberry pi
ssh pi@192.168.1.79

# check the status of the daemon
sudo systemctl status lifepo4wered-daemon.service
```

At this time, the blinking LiFePO4wered/Pi3 PWR LED should now go on solid.
If the PWR LED does not yet go on solid,
it is likely that the I2C was not yet enabled before the installer was run,
and a reboot is required.

The only necessary user interaction is with the touch button,
with feedback provided by the green PWR LED.
The LiFePO4wered/Pi3 touch button can be used to turn the Raspberry Pi on and off.
The touch button needs to be pressed and held to take effect.
During this press-and-hold delay, the PWR LED glow will ramp up.
During booting or shutdown,
if the user touches the button during this time,
the PWR LED will do a quick flashing sequence to
indicate it cannot comply with the user request at that time.

To make it convenient to interact with the LiFePO4wered/Pi3,
the software package installed on the RPi provides a command line tool.

```bash
# get help message
lifepo4wered-cli

# get the current battery voltage
# returns the battery voltage in millivolts
lifepo4wered-cli get vbat

# get the supply voltage
# returns the  raspberry pi supply battery voltage in millivolts
lifepo4wered-cli get vout

# to set the wake time to an hour
# if you shut down the Raspberry Pi, it will wake up again in about 60 minutes
lifepo4wered-cli set wake_time 60

# Raspberry Pi to always run whenever there is power to do so
lifepo4wered­cli set auto_boot 1

# set the auto-boot flag to make the rpi run whenever there is power to do so,
# but still be able to turn the rpi off with the button or from software
lifepo4wered-cli set auto_boot 2
```

# Software Configuration

# Overclocking
* [I Wrote a Paper for a PhD Course on an Overclocked Raspberry Pi 4](https://medium.com/an-idea/i-wrote-a-paper-for-a-phd-course-on-an-overclocked-raspberry-pi-4-cb14c9210ed4)
* [What accessories do I need to overclock my Raspberry Pi 3 B+?](https://www.androidcentral.com/what-accessories-do-i-need-overclock-my-raspberry-pi-3-b)
* config.txt - Overclocking options - https://www.raspberrypi.org/documentation/configuration/config-txt/overclocking.md
* [Overclock Your Raspberry Pi The Right Way](https://hackaday.com/2018/01/16/__trashed-5/)
* [How to Overclock Any Raspberry Pi](https://www.tomshardware.com/how-to/overclock-any-raspberry-pi)

# Reading Processor Temperature and Clock Speed
https://www.elinux.org/RPI_vcgencmd_usage

vcgencmd get_config int

```bash
# processor temperature
vcgencmd measure_temp
/opt/vc/bin/vcgencmd measure_temp
```

```bash
# clock speed
$ vcgencmd measure_clock arm
frequency(45)=600000000

$ vcgencmd measure_clock core
frequency(1)=250000000
```



[01]:https://microsoft.github.io/ELL/tutorials/Active-cooling-your-Raspberry-Pi-3/
[02]:https://microsoft.github.io/ELL/gallery/Raspberry-Pi-3-Fan-Mount/
[03]:https://microsoft.github.io/ELL/
[05]:https://www.viewstl.com/
[06]:https://www.shapeways.com/
[07]:https://en.wikipedia.org/wiki/STL_(file_format)
[08]:https://www.protolabs.com/
[09]:https://cdn.tindiemedia.com/images/resize/NS8E-8h1An68bOqZrKHhnukm44c=/full-fit-in/2400x1600/smart/58262/products/2016-12-15T20%3A35%3A06.599Z-IMGP8966.JPG
[10]:https://lifepo4wered.com/lifepo4wered-pi.html
[11]:https://www.tindie.com/products/xorbit/lifepo4weredpi3/
[12]:https://github.com/xorbit/LiFePO4wered-Pi
[13]: https://lifepo4wered.com/files/LiFePO4wered-Pi3-Product-Brief.pdf
[14]:https://www.tindie.com/products/mjrice/enclosure-for-raspberry-pi-3-and-lifepo4weredpi3/

