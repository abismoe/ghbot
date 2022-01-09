defmodule GhbotDiscord.Interactions.PingInteraction do
  @moduledoc """
  Registers a slash command for a ping/pong liveliness check.
  """

  alias Nostrum.Api
  alias Nostrum.Struct.Interaction

  def command_name, do: "gh_ping"

  def command_definition,
    do: %{
      name: command_name(),
      description: "Ping/Pong liveliness check for GhBot.",
      options: []
    }

  def command_version, do: 1

  def handle(%Interaction{} = interaction) do
    response = %{
      type: 4,
      data: %{
        content: "Pong!"
      }
    }

    Api.create_interaction_response(interaction, response)
  end

  def handle(_), do: :ignore
end
