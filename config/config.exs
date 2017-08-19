# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :todo_app2,
  ecto_repos: [TodoApp2.Repo]

# Configures the endpoint
config :todo_app2, TodoApp2.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "rYXW5kgmn+lMKvqkLpniKGfYUNrFdEsH0Tb53Vkm80ga440+1mbYhTmyOgEmmqWj",
  render_errors: [view: TodoApp2.ErrorView, accepts: ~w(html json)],
  pubsub: [name: TodoApp2.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :template_engines,
  drab: Drab.Live.Engine

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
