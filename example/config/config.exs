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
  init: [:nerves_runtime],
  app: Mix.Project.config()[:app]

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

config :example, :qt_webengine_kiosk,
  url: System.get_env("KIOSK_URL") || "https://www.google.com"
# Import target specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
# Uncomment to use target specific configurations

# import_config "#{Mix.Project.config()[:target]}.exs"
