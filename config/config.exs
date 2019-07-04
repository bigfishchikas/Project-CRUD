# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :prater,
  ecto_repos: [Prater.Repo]

# Configures the endpoint
config :prater, PraterWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "4VlB3SJhkK516Mg+LvWHxFVF8ZJZ1nb46VMY3WoYfBliebjsnzr4t3B1CXfO1r6n",
  render_errors: [view: PraterWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Prater.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :hound, driver: "phantomjs"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
