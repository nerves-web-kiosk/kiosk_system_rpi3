defmodule Example.MixProject do
  use Mix.Project

  @all_targets [:rpi3]

  def project do
    [
      app: :example,
      version: "1.0.0",
      elixir: "~> 1.8",
      archives: [nerves_bootstrap: "~> 1.0"],
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      aliases: [loadconfig: [&bootstrap/1]],
      deps: deps()
    ]
  end

  # Starting nerves_bootstrap adds the required aliases to Mix.Project.config()
  # Aliases are only added if MIX_TARGET is set.
  def bootstrap(args) do
    Application.start(:nerves_bootstrap)
    Mix.Task.run("loadconfig", args)
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [mod: {Example.Application, []}, extra_applications: [:logger]]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # Dependencies for all targets
      {:nerves, "~> 1.4", runtime: false},
      {:shoehorn, "~> 0.4"},
      {:ring_logger, "~> 0.6"},
      {:toolshed, "~> 0.2"},
      {:webengine_kiosk, "~> 0.1"},

      # Dependencies for all targets except host
      {:nerves_runtime, "~> 0.6", targets: @all_targets},
      {:nerves_init_gadget, "~> 0.4", targets: @all_targets},
      {:nerves_time, "~> 0.2", targets: @all_targets},

      # Dependencies for specific targets
      {:kiosk_system_rpi3, path: "../", runtime: false, targets: :rpi3}
    ]
  end
end
