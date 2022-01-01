import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :ghbot_core, GhbotCore.Repo,
  database: Path.expand("../ghbot_core_test.db", Path.dirname(__ENV__.file)),
  pool_size: 5,
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :ghbot_web, GhbotWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "+VfkRLEFk3ZJEjqej/iDZyhMllCE8OoWy8PFG2/k2h/Jndh52CLZE50pyHODV7Gh",
  server: false
