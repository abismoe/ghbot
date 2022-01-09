defmodule GhbotDiscord.GlobalHandlers.SelectionHandler do
  require Logger

  alias GhbotDiscord.Interactions
  alias Nostrum.Struct.Interaction

  def handle(%Interaction{data: %{custom_id: name}} = interaction) do
    handler = Map.get(Interactions.selections(), name)

    if handler do
      Logger.debug("Handling selection by #{handler}.")
      handler.handle(interaction)
    else
      Logger.debug("No handler registered for this selection; ignoring.")
      :ignore
    end
  end
end
