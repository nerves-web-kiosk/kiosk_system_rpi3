if Mix.env == :test do
  hash = :os.cmd('git rev-parse HEAD')
    |> to_string
    |> String.trim
  System.put_env("NERVES_FW_VCS_IDENTIFIER", hash)
end

defmodule KioskSystemRpi3.Mixfile do
  use Mix.Project

  @app :kiosk_system_rpi3
  @version Path.join(__DIR__, "VERSION")
           |> File.read!()
           |> String.trim()

  def project do
    [
      app: @app,
      version: @version,
      elixir: "~> 1.4",
      compilers: Mix.compilers() ++ [:nerves_package],
      nerves_package: nerves_package(),
      description: description(),
      package: package(),
      deps: deps(),
      nerves_package: nerves_package(),
      aliases: ["deps.precompile": ["nerves.env", "nerves.precompile", "deps.precompile"],
      "deps.loadpaths":  ["deps.loadpaths", "nerves.loadpaths"]]
    ]
  end

  def application do
    []
  end

  def nerves_package do
    [
      type: :system,
      version: @version,
      compiler: :nerves_package,
      artifact_url: [
        "https://github.com/letoteteam/#{@app}/releases/download/v#{@version}/#{@app}-v#{@version}.tar.gz",
      ],
      platform: Nerves.System.BR,
      platform_config: [
        defconfig: "nerves_defconfig",
      ],
      checksum: package_files()
    ]
  end

  defp deps do
    [
      {:nerves, "~> 0.8", runtime: false},
      {:nerves_system_br, "~> 0.15.0", runtime: false, app: false},
      {:nerves_toolchain_arm_unknown_linux_gnueabihf, "~> 0.12.0", runtime: false, app: false}
    ]
  end

  defp description do
    """
    Nerves System - Raspberry Pi 3 B Kiosk
    """
  end

  defp package do
    [
      maintainers: ["Justin Schneck", "Greg Mefford", "Jeff Smith"],
      files: package_files(),
      licenses: ["Apache 2.0"],
      links: %{"Github" => "https://github.com/letoteteam/#{@app}"}
    ]
  end

  defp package_files do
    [
      "LICENSE",
      "mix.exs",
      "README.md",
      "CHANGELOG.md",
      "nerves_defconfig",
      "rootfs_overlay",
      "linux-4.4.defconfig",
      "fwup.conf",
      "cmdline.txt",
      "config.txt",
      "post-createfs.sh",
      "VERSION"
    ]
  end
end
