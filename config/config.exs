# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :tater,
  ecto_repos: [Tater.Repo]

# Configures the endpoint
config :tater, Tater.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "+Z5W4AgfQ9uhiWtEjXa9+hw4vEzs1ITchPOKFzRSt/n8mbI83hoYaXGTUtdaXUaq",
  render_errors: [view: Tater.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Tater.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :scrivener_html,
  view_style: :semantic

if Mix.env == :dev do
  # clear console before each test run
  config :mix_test_watch, clear: true
end

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
