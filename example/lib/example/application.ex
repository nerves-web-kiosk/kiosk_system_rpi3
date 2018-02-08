defmodule Example.Application do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false
    iface = Application.get_env(:nerves_network, :iface)
    init0()
    # Define workers and child supervisors to be supervised
    children = [
      worker(SystemRegistry.Task, [
        [:state, :network_interface,  iface, :ipv4_address],
        &init1/1])
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Example.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def init0 do
    # initial sound drivers
    ###
      # Certain machines will have multiple sound cards.
      # Lets try to initialize 0, 1 and then check if card 1
      # is present by listing them.
      #
      # aplay -l
      # card 1: THISCARD
      #
      # Then we need to export the env var with the value pulled from the card list
      # export ALSA_CARD THISCARD

    # Enum.each([0, 1], &:os.cmd('alsactl init #{&1}'))
    # {ret, 0} = System.cmd("aplay", ["-l"])
    # case Regex.run ~r/card 1: (\w*)/, ret do
    #   [_, card] ->
    #     System.put_env("ALSA_CARD", card)
    #   _ -> :noop
    # end

    # Initialize udev :(
    :os.cmd('udevd -d');
    :os.cmd('udevadm trigger --type=subsystems --action=add');
    :os.cmd('udevadm trigger --type=devices --action=add');
    :os.cmd('udevadm settle --timeout=30');

  end

  def init1(_delta) do
    # You will need to wait until the time is set if you point
    # to an ssl domain
    # :timer.sleep(200)
    # init_ntp("time.nist.gov")
    # :timer.sleep(200)
    init_ui()
  end

  def init_ui() do
    System.put_env("QTWEBENGINE_REMOTE_DEBUGGING", "9222")
    System.put_env("QTWEBENGINE_CHROMIUM_FLAGS", "--disable-embedded-switches")
    System.cmd("qt-webengine-kiosk", ["-c", "/etc/qt-webengine-kiosk.ini", "--opengl", "NATIVE"])
  end

  def init_ntp(ntp_server) do
    # ntpd in busybox is limited so this requires a two step dance.
    # Stop existing instances of ntpd first.
    System.cmd("killall", ["-q", "-SIGINT", "ntpd"])
    # Run once and quit to block until clock is set.
    System.cmd("ntpd", ["-n", "-q", "-p", ntp_server])
    # Then run as a daemon in the background to keep clock in sync.
    System.cmd("ntpd", ["-p", ntp_server])
  end

  def start_remote_debugger() do
    System.cmd("socat", ["tcp-listen:9223,fork", "tcp:localhost:9222"])
  end
end
