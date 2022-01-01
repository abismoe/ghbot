defmodule GhbotCore.Github.Token do
  use Joken.Config

  def token_config do
    now = DateTime.to_unix(DateTime.utc_now())

    %{}
    |> add_claim("iat", fn -> now end)
    |> add_claim("exp", fn -> now + 600 end)
    |> add_claim("iss", fn -> app_id() end)
  end

  defp app_id, do: Application.get_env(:ghbot_core, :app_id)
end
