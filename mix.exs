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
     aliases: ["deps.precompile": ["nerves.env", "nerves.precompile", "deps.precompile"],
     "deps.loadpaths":  ["deps.loadpaths", "nerves.loadpaths"]]]
  end

  def application do
    []
  end

  defp deps do
    [
      {:nerves, "~> 0.7"},
      {:nerves_system_br, "~> 0.13.3"},
      {:nerves_toolchain_arm_unknown_linux_gnueabihf, "~> 0.10.0"}
    ]
  end

  defp description do
    """
    Nerves System - Raspberry Pi 3 B Kiosk
    """
  end

  defp package do
   [maintainers: ["Justin Schneck"],
    files: ["LICENSE", "mix.exs", "nerves_defconfig", "nerves.exs", "README.md", "VERSION", "rootfs_overlay", "fwup.conf", "cmdline.txt", "linux-4.4.defconfig", "config.txt", "post-createfs.sh"],
    licenses: ["Apache 2.0"],
    links: %{"Github" => "https://github.com/letoteteam/kiosk_system_rpi3"}]
  end
end
