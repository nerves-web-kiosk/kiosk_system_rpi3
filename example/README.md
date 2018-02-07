# Example

`kiosk_system_rpi3` example app

## Getting Started

To start your Nerves app:

Set the target
```bash
export MIX_TARGET=rpi3
```

Set the url to display
```bash
export KIOSK_URL=https://google.com
```

Build and Burn firmware
```bash
mix do deps.get, firmware, firmware.burn
```
