defmodule Tater.Mixfile do
  use Mix.Project

  def project do
    [app: :tater,
     version: "0.2.0",
     elixir: "~> 1.2",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix, :gettext] ++ Mix.compilers,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     aliases: aliases(),
     deps: deps()]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [mod: {Tater, []}, applications:
      [:phoenix, :phoenix_pubsub, :phoenix_html, :cowboy, :logger, :gettext,
       :phoenix_ecto, :postgrex, :timex_ecto, :scrivener_ecto, :scrivener_html,
       :phoenix_html_simplified_helpers, :logger_file_backend]]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_),     do: ["lib", "web"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [{:phoenix, "~> 1.2.4"},
     {:phoenix_pubsub, "~> 1.0"},
     {:phoenix_ecto, "~> 3.0"},
     {:postgrex, ">= 0.0.0"},
     {:phoenix_html, "~> 2.6"},
     {:phoenix_live_reload, "~> 1.0", only: :dev},
     {:gettext, "~> 0.11"},
     {:cowboy, "~> 1.0"},
     {:mix_test_watch, "~> 0.3", only: :dev, runtime: false},
     {:ex_unit_notifier, "~> 0.1", only: :test},
     {:dogma, "~> 0.1", only: :dev},
     {:scrivener_ecto, "~> 1.0"},
     {:scrivener_html, "~> 1.7"},
     {:faker, "~> 0.8", only: :dev},
     {:phoenix_html_simplified_helpers, "~> 1.2"},
     {:distillery, "~> 1.4", runtime: false},
     {:logger_file_backend, "~> 0.0.10"}]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    ["ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
     "ecto.reset": ["ecto.drop", "ecto.setup"],
     "test": ["ecto.create --quiet", "ecto.migrate", "test"]]
  end
end
