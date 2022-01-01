defmodule GhbotDiscord.Commands.InstallationsCommand do
  @moduledoc """
  Registers a slash command for fetching installations and binding to
  one of them.
  """

  require Logger

  alias GhbotCore.Github.Installation
  alias Nostrum.Api
  alias Nostrum.Struct.Interaction

  @name "gh_bind_installation"
  @select_name "installation_select"

  @command %{
    name: @name,
    description: "Bind an installation to this server.",
    options: []
  }

  def command_definition, do: @command

  def handle(%Interaction{} = interaction) do
    response =
      with {:ok, installations} <- Installation.fetch_all() do
        select_options =
          Enum.map(installations, fn %Installation{name: name, type: type} ->
            %{
              label: name,
              value: name,
              description: "#{type}: #{name}."
            }
          end)

        %{
          type: 4,
          data: %{
            content: "Pick the installation from below.",
            components: [
              %{
                type: 1,
                components: [
                  %{
                    type: 3,
                    custom_id: @select_name,
                    options: select_options
                  }
                ]
              }
            ]
          }
        }
      else
        _ ->
          %{
            type: 4,
            data: %{
              content: "Error: couldn't fetch installations."
            }
          }
      end

    Api.create_interaction_response(interaction, response)
  end

  def handle(_), do: :ignore

  def handle_select(
        %Interaction{data: %{custom_id: "installation_select", values: [value]}} = interaction
      ) do
    response = %{
      type: 4,
      data: %{
        content: "You've binding this server to: #{value}.\n\n(Note: nothing was bound yet.)"
      }
    }

    Api.create_interaction_response(interaction, response)
  end

  def handle_select(%Interaction{} = interaction) do
    response = %{
      type: 4,
      data: %{
        content: "Error: I don't know how to handle that interaction."
      }
    }

    Logger.error("Unhandled select interaction in installations_command")
    Logger.error(inspect(interaction))

    Api.create_interaction_response(interaction, response)
  end
end
