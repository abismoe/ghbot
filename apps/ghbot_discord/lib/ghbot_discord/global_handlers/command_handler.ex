defmodule GhbotDiscord.GlobalHandlers.CommandHandler do
  require Logger

  alias GhbotDiscord.Interactions
  alias GhbotDiscord.Interactions.InstallInteraction
  alias Nostrum.Struct.Interaction

  @install_command_name InstallInteraction.command_name()

  def handle(%Interaction{data: %{name: @install_command_name}} = interaction) do
    InstallInteraction.handle(interaction)
  end

  def handle(%Interaction{data: %{name: name}} = interaction) do
    handler = Map.get(Interactions.commands(), name)

    if handler do
      Logger.debug("Handling command by #{handler}.")
      handler.handle(interaction)
    else
      Logger.debug("No handler registered for this command; ignoring.")
      :ignore
    end
  end
end
