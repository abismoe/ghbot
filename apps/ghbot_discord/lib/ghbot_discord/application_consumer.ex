defmodule GhbotDiscord.ApplicationConsumer do
  @moduledoc """
  The catch-all consumer for the bot. The strategy here is to have only
  one consumer that then delegates processing responsibilities to
  handlers.
  """

  use Nostrum.Consumer

  require Logger

  alias GhbotDiscord.GlobalHandlers.ReadyHandler
  alias Nostrum.Struct.Interaction

  @message_handlers [
    GhbotDiscord.MessageHandlers.PingHandler
  ]

  def start_link do
    Consumer.start_link(__MODULE__)
  end

  def handle_event({:READY, _, _}) do
    Logger.info("Running on boot setup.")
    ReadyHandler.handle()
    Logger.info("Boot setup done.")
  end

  def handle_event({:INTERACTION_CREATE, %Interaction{} = interaction, _}) do
    Logger.debug("Received interaction #{inspect(interaction)}")
    result = GhbotDiscord.GlobalHandlers.InteractionHandler.handle(interaction)
    Logger.debug("Result after handling interaction: #{inspect(result)}")
    result
  end

  def handle_event({:MESSAGE_CREATE, msg, _}) do
    Enum.each(@message_handlers, fn handler ->
      handler.handle(msg)
    end)
  end

  def handle_event(_) do
    :noop
  end
end
