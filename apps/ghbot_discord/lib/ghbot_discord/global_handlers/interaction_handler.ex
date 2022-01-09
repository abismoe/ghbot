defmodule GhbotDiscord.GlobalHandlers.InteractionHandler do
  require Logger

  alias Nostrum.Struct.Interaction

  def handle(%Interaction{data: %{name: _}} = interaction) do
    Logger.debug("Interaction is a command; passing to command handler.")
    GhbotDiscord.GlobalHandlers.CommandHandler.handle(interaction)
  end

  def handle(%Interaction{data: %{component_type: 3}} = interaction) do
    Logger.debug("Interaction is a selection; passing to selection handler.")
    GhbotDiscord.GlobalHandlers.SelectionHandler.handle(interaction)
  end

  def handle(_) do
    Logger.debug("Unidentified interaction type; ignoring.")
    :ignore
  end
end
