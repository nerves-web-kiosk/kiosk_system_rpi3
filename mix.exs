defmodule KioskSystemRpi3.MixProject do
  use Mix.Project

  @app :kiosk_system_rpi3
  @version Path.join(__DIR__, "VERSION")
           |> File.read!()
           |> String.trim()

  def project do
    [
      app: @app,
      version: @version,
      elixir: "~> 1.8",
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
    set_target()
    Application.start(:nerves_bootstrap)
    Mix.Task.run("loadconfig", args)
  end

  defp nerves_package do
    [
      type: :system,
      artifact_sites: [
        {:github_releases, "letoteteam/#{@app}"}
      ],
      build_runner_opts: build_runner_opts(),
      platform: Nerves.System.BR,
      platform_config: [
        defconfig: "nerves_defconfig"
      ],
      checksum: package_files()
    ]
  end

  defp deps do
    [
      {:nerves, "~> 1.5.4 or ~> 1.6.0", runtime: false},
      {:nerves_system_br, "1.11.0", runtime: false},
      {:nerves_toolchain_arm_unknown_linux_gnueabihf, "~> 1.3.0", runtime: false},
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
      files: package_files(),
      licenses: ["Apache 2.0"],
      links: %{"GitHub" => "https://github.com/letoteteam/#{@app}"}
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
      "linux-4.19.defconfig",
      "logo_custom_clut224.ppm",
      "mix.exs",
      "nerves_defconfig",
      "post-build.sh",
      "post-createfs.sh",
      "ramoops.dts",
      "README.md",
      "users_table.txt",
      "VERSION"
    ]
  end

  defp build_runner_opts() do
    if primary_site = System.get_env("BR2_PRIMARY_SITE") do
      [make_args: ["BR2_PRIMARY_SITE=#{primary_site}", "PARALLEL_JOBS=8"]]
    else
      [make_args: ["PARALLEL_JOBS=8"]]
    end
  end

  defp set_target() do
    if function_exported?(Mix, :target, 1) do
      apply(Mix, :target, [:target])
    else
      System.put_env("MIX_TARGET", "target")
    end
  end
end
