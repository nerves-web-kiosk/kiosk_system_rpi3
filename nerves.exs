use Mix.Config

version =
  Path.join(__DIR__, "VERSION")
  |> File.read!
  |> String.strip

pkg = :kiosk_system_rpi3

config pkg, :nerves_env,
  type: :system,
  version: version,
  compiler: :nerves_package,
  platform: Nerves.System.BR,
  platform_config: [
    defconfig: "nerves_defconfig"
  ],
  provider_config: [
    docker: {"Dockerfile", "kiosk_system_rpi3:0.11.0"}
  ],
  checksum: [
    "nerves_defconfig",
    "rootfs-additions",
    "linux-4.4.defconfig",
    "fwup.conf",
    "cmdline.txt",
    "config.txt",
    "post-createfs.sh",
    "VERSION"
  ]
