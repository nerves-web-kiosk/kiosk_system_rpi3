defmodule KioskSystemRpi3.MixProject do
  use Mix.Project

  @app :kiosk_system_rpi3
  @version Path.join(__DIR__, "VERSION")
           |> File.read!()
           |> String.trim()
  build_runner =
    if System.get_env("CI") != nil do
      Nerves.Artifact.BuildRunners.Local
    else
      Nerves.Artifact.BuildRunners.Docker
    end

  @build_runner build_runner

  def project do
    [
      app: @app,
      version: @version,
      elixir: "~> 1.6",
      archives: [nerves_bootstrap: "~> 1.0"],
      compilers: Mix.compilers() ++ [:nerves_package],
      nerves_package: nerves_package(),
      description: description(),
      package: package(),
      deps: deps(),
      aliases: [loadconfig: [&bootstrap/1]],
      docs: [extras: ["README.md"], main: "readme"]
    ]
  end

  def application do
    []
  end

  defp bootstrap(args) do
    System.put_env("MIX_TARGET", "rpi3")
    Application.start(:nerves_bootstrap)
    Mix.Task.run("loadconfig", args)
  end

  defp nerves_package do
    [
      type: :system,
      artifact_sites: [
        {:github_releases, "letoteteam/#{@app}"}
      ],
      build_runner: @build_runner,
      build_runner_opts: [make_args: ["PARALLEL_JOBS=8"]],
      platform: Nerves.System.BR,
      platform_config: [
        defconfig: "nerves_defconfig"
      ],
      checksum: package_files()
    ]
  end

  defp deps do
    [
      {:nerves, "~> 1.3", runtime: false},
      {:nerves_system_br, "1.5.4", runtime: false},
      {:nerves_toolchain_arm_unknown_linux_gnueabihf, "1.1.0", runtime: false},
      {:nerves_system_linter, "~> 0.3.0", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.18", only: [:dev, :test], runtime: false}
    ]
  end

  defp description do
    """
    Nerves QtWebEngine Kiosk System - Raspberry Pi 3 B and B+
    """
  end

  defp package do
    [
      maintainers: ["Justin Schneck"],
      files: package_files(),
      licenses: ["Apache 2.0"],
      links: %{"Github" => "https://github.com/letoteteam/#{@app}"}
    ]
  end

  defp package_files do
    [
      "fwup_include",
      "patches",
      "rootfs_overlay",
      "CHANGELOG.md",
      "cmdline.txt",
      "Config.in",
      "config.txt",
      "fwup-revert.conf",
      "fwup.conf",
      "LICENSE",
      "linux-4.14.defconfig",
      "logo_custom_clut224.ppm",
      "mix.exs",
      "nerves_defconfig",
      "post-build.sh",
      "post-createfs.sh",
      "README.md",
      "users_table.txt",
      "VERSION"
    ]
  end
end
