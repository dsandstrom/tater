# use notifier after tests
ExUnit.configure formatters: [ExUnit.CLIFormatter, ExUnitNotifier]
ExUnit.start

Ecto.Adapters.SQL.Sandbox.mode(Tater.Repo, :manual)
