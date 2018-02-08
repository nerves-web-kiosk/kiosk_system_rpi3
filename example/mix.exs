defmodule Example.MixProject do
  use Mix.Project

  @target System.get_env("MIX_TARGET") || "host"

  Mix.shell().info([
    :green,
    """
    Mix environment
      MIX_TARGET:   #{@target}
      MIX_ENV:      #{Mix.env()}
    """,
    :reset
  ])

  def project do
    [
      app: :example,
      version: "0.1.0",
      elixir: "~> 1.4",
      target: @target,
      archives: [nerves_bootstrap: "~> 0.7"],
      deps_path: "deps/#{@target}",
      build_path: "_build/#{@target}",
      lockfile: "mix.lock.#{@target}",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      aliases: aliases(@target),
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application, do: application(@target)

  # Specify target specific application configurations
  # It is common that the application start function will start and supervise
  # applications which could cause the host to fail. Because of this, we only
  # invoke Example.start/2 when running on a target.
  def application("host") do
    [extra_applications: [:logger]]
  end

  def application(_target) do
    [mod: {Example.Application, []}, extra_applications: [:logger]]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:nerves, "~> 0.9", runtime: false},
      {:logger_circular_buffer, "~> 0.2"}
    ] ++ deps(@target)
  end

  # Specify target specific dependencies
  defp deps("host"), do: []

  defp deps(target) do
    [
      {:shoehorn, "~> 0.2"},
      {:nerves_runtime, "~> 0.4"},
      {:nerves_network, "~> 0.3"},
      {:nerves_init_gadget, "~> 0.1"},
    ] ++ system(target)
  end

  defp system("rpi3"), do: [{:kiosk_system_rpi3, path: "../", runtime: false}]
  defp system(target), do: Mix.raise "Unknown MIX_TARGET: #{target}"

  # We do not invoke the Nerves Env when running on the Host
  defp aliases("host"), do: []

  defp aliases(_target) do
    [
      # Add custom mix aliases here
    ]
    |> Nerves.Bootstrap.add_aliases()
  end
end
