defmodule GhbotCore.Github do
  def accepts_header, do: "application/vnd.github.v3+json"

  def authorization_header do
    {:ok, jwt, _} = GhbotCore.Github.Token.generate_and_sign()

    "Bearer " <> jwt
  end

  def headers do
    [
      Authorization: authorization_header(),
      Accepts: accepts_header()
    ]
  end
end
