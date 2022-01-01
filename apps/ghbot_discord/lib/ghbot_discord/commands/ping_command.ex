defmodule GhbotDiscord.Commands.PingCommand do
  @moduledoc """
  Registers a slash command for a ping/pong liveliness check.
  """

  alias Nostrum.Api
  alias Nostrum.Struct.Interaction

  @name "gh_ping"

  @command %{
    name: @name,
    description: "Ping/Pong liveliness check for GhBot.",
    options: []
  }

  def command_definition, do: @command

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
