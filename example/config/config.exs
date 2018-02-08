# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Customize the firmware. Uncomment all or parts of the following
# to add files to the root filesystem or modify the firmware
# archive.

# config :nerves, :firmware,
#   rootfs_overlay: "rootfs_overlay",
#   fwup_conf: "config/fwup.conf"

# Use shoehorn to start the main application. See the shoehorn
# docs for separating out critical OTP applications such as those
# involved with firmware updates.
config :shoehorn,
  init: [:nerves_runtime, :nerves_init_gadget],
  app: Mix.Project.config()[:app]

config :nerves, :firmware,
  rootfs_overlay: "rootfs_overlay"

# Add the LoggerCircularBuffer backend. This removes the
# default :console backend.
config :logger, backends: [LoggerCircularBuffer]

# Set the number of messages to hold in the circular buffer
config :logger, LoggerCircularBuffer, buffer_size: 100

network_ssid = System.get_env("NERVES_NETWORK_SSID")
network_psk = System.get_env("NERVES_NETWORK_PSK")

network_iface = System.get_env("NERVES_NETWORK_IFACE") || "eth0"
key_mgmt = System.get_env("NERVES_NETWORK_KEY_MGMT") || "WPA-PSK"

wlan_conf =
  if network_iface == "wlan0" do
    config :nerves_network, :default,
      wlan0: [ssid: network_ssid, psk: network_psk, key_mgmt: key_mgmt]
  else
    config :nerves_network, :default,
      eth0: [ipv4_address_method: :dhcp]
  end

config :nerves_network,
  iface: network_iface

config :nerves_init_gadget,
  ifname: "eth0",
  address_method: :dhcp,
  mdns_domain: "kiosk.local",
  node_name: "kiosk",
  node_host: :mdns_domain

config :nerves_firmware_ssh,
  authorized_keys: [
    File.read!(Path.join(System.user_home!, ".ssh/id_rsa.pub"))
  ]
# Import target specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
# Uncomment to use target specific configurations

# import_config "#{Mix.Project.config()[:target]}.exs"
