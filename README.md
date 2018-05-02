# Raspberry Pi 3 Kiosk

Implements `qt-webkit-kiosk` for rendering webkit.

This is the base Nerves System configuration for the Raspberry Pi 3 Model B.

![Fritzing Raspberry Pi 3 image](assets/images/raspberry-pi-3-model-b.png)
<br><sup>[Image credit](#fritzing)</sup>

| Feature              | Description                     |
| -------------------- | ------------------------------- |
| CPU                  | 1.2 GHz quad-core ARMv8         |
| Memory               | 1 GB DRAM                       |
| Storage              | MicroSD                         |
| Linux kernel         | 4.4.43 w/ Raspberry Pi patches  |
| IEx terminal         | HDMI and USB keyboard (can be changed to UART)   |
| GPIO, I2C, SPI       | Yes - Elixir ALE                |
| ADC                  | No                              |
| PWM                  | Yes, but no Elixir support      |
| UART                 | 1 available - ttyS0             |
| Camera               | Yes - via rpi-userland          |
| Ethernet             | Yes                             |
| WiFi                 | Yes - Nerves.InterimWiFi        |
| Bluetooth            | Not yet                         |

## Using

The most common way of using this Nerves System is create a project with `mix
nerves.new` and to export `MIX_TARGET=rpi0`. See the [Getting started
guide](https://hexdocs.pm/nerves/getting-started.html#creating-a-new-nerves-app)
for more information.

If you need custom modifications to this system for your device, clone this
repository and update as described in [Making custom
systems](https://hexdocs.pm/nerves/systems.html#customizing-your-own-nerves-system)

See the [example project](https://github.com/LeToteTeam/kiosk_system_rpi3/tree/master/example) for more info


## Building

Building this image require running under docker.
If you are compiling locally, your instance of docker will need to have at least
8gb of ram assigned to it.

## Built-in WiFi Firmware

WiFi modules almost always require proprietary firmware to be loaded for them to work. The
Linux kernel handles this and firmware blobs are maintained in the
`linux-firmware` project. The firmware for the built-in WiFi module on the RPi3
hasn't made it to the `linux-firmware` project nor Buildroot, so it is included
here in a `rootfs-additions` overlay directory. The original firmware files came from
https://github.com/RPi-Distro/firmware-nonfree/blob/master/brcm80211/brcm.

[Image credit](#fritzing): This image is from the [Fritzing](http://fritzing.org/home/) parts library.
