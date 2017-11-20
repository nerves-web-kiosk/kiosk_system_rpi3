if Mix.env == :test do
  hash = :os.cmd('git rev-parse HEAD')
    |> to_string
    |> String.trim
  System.put_env("NERVES_FW_VCS_IDENTIFIER", hash)
end

defmodule KioskSystemRpi3.Mixfile do
  use Mix.Project

  @version Path.join(__DIR__, "VERSION")
    |> File.read!
    |> String.trim

  def project do
    [app: :kiosk_system_rpi3,
     version: @version,
     elixir: "~> 1.3",
     compilers: Mix.compilers ++ [:nerves_package],
     description: description(),
     package: package(),
     deps: deps(),
     nerves_package: nerves_package(),
     aliases: ["deps.precompile": ["nerves.env", "nerves.precompile", "deps.precompile"],
     "deps.loadpaths":  ["deps.loadpaths", "nerves.loadpaths"]]]
  end

  def application do
    []
  end

  defp deps do
    [{:nerves, "~> 0.8"},
     {:nerves_system_br, "~> 0.15.0", runtime: false, app: false},
     {:nerves_toolchain_arm_unknown_linux_gnueabihf, "~> 0.10.0"}]
  end

  defp description do
    """
    Nerves System - Raspberry Pi 3 B Kiosk
    """
  end

  defp package do
   [maintainers: ["Justin Schneck", "Greg Mefford", "Jeff Smith"],
    files: ["LICENSE", "mix.exs", "nerves_defconfig", "README.md", "VERSION", "rootfs_overlay", "fwup.conf", "cmdline.txt", "linux-4.4.defconfig", "config.txt", "post-createfs.sh"],
    licenses: ["Apache 2.0"],
    links: %{"Github" => "https://github.com/letoteteam/kiosk_system_rpi3"}]
  end

  def nerves_package do
    [type: :system,
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
     ]]
  end
end
