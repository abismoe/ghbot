defmodule GhbotCore.Repo do
  use Ecto.Repo,
    otp_app: :ghbot_core,
    adapter: Ecto.Adapters.SQLite3
end
