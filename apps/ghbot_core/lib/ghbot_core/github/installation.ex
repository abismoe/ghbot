defmodule GhbotCore.Github.Installation do
  @moduledoc """
  A Github Application Installation.
  """

  alias GhbotCore.Github
  alias GhbotCore.Github.Installation

  defstruct [:name, :type]

  def fetch_all do
    with {:ok, %{body: body}} <-
           HTTPoison.get("https://api.github.com/app/installations", Github.headers()),
         {:ok, installations} = Jason.decode(body) do
      {:ok,
       Enum.map(installations, fn %{"account" => account} ->
         %Installation{name: account["login"], type: account["type"]}
       end)}
    end
  end
end
