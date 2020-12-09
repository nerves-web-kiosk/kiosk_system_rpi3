defmodule Example.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  @target Mix.target()

  use Application

  def start(_type, _args) do
    platform_init(@target)

    opts = [strategy: :one_for_one, name: Example.Supervisor]
    webengine_opts = Application.get_all_env(:webengine_kiosk)

    children =
      [
        # Children for all targets
        # Starts a worker by calling: Example.Worker.start_link(arg)
        {WebengineKiosk, {webengine_opts, name: Display}}
      ] ++ children(target())

    Supervisor.start_link(children, opts)
  end

  # List all child processes to be supervised
  def children(:host) do
    [
      # Children that only run on the host
      # Starts a worker by calling: Example.Worker.start_link(arg)
      # {Example.Worker, arg},
    ]
  end

  def children(_target) do
    [
      # Children for all targets except host
      # Starts a worker by calling: Example.Worker.start_link(arg)
      # {Example.Worker, arg},
    ]
  end

  defp platform_init(:host), do: :ok

  defp platform_init(_target) do
    :os.cmd('udevd -d')
    :os.cmd('udevadm trigger --type=subsystems --action=add')
    :os.cmd('udevadm trigger --type=devices --action=add')
    :os.cmd('udevadm settle --timeout=30')

    System.put_env("QTWEBENGINE_CHROMIUM_FLAGS", "--disable-gpu --disable-dev-shm-usage")
  end

  def target() do
    Application.get_env(:example, :target)
  end
end
