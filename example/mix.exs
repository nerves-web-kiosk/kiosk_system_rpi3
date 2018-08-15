defmodule Example.MixProject do
  use Mix.Project

  @target System.get_env("MIX_TARGET") || "host"

  def project do
    [
      app: :example,
      version: "1.0.0",
      elixir: "~> 1.4",
      target: @target,
      archives: [nerves_bootstrap: "~> 1.0"],
      deps_path: "deps/#{@target}",
      build_path: "_build/#{@target}",
      lockfile: "mix.lock.#{@target}",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      aliases: ["loadconfig": [&bootstrap/1]],
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
      {:nerves, "~> 1.0", runtime: false},
      {:ring_logger, "~> 0.4"},
      {:shoehorn, "~> 0.2"}
    ] ++ deps(@target)
  end

  # Specify target specific dependencies
  defp deps("host"), do: []

  defp deps(target) do
    [
      {:nerves_runtime, "~> 0.4"},
      {:nerves_network, "~> 0.3"},
      {:nerves_init_gadget, "~> 0.1"},
      {:nerves_time, "~> 0.2"},
      {:webengine_kiosk, "~> 0.1"},
    ] ++ system(target)
  end

  defp system("rpi3"), do: [{:kiosk_system_rpi3, path: "../", runtime: false}]
  defp system(target), do: Mix.raise "Unknown MIX_TARGET: #{target}"

end
