defmodule GhbotDiscord.ApplicationConsumer do
  @moduledoc """
  The catch-all consumer for the bot. The strategy here is to have only
  one consumer that then delegates processing responsibilities to
  handlers.
  """

  use Nostrum.Consumer

  require Logger

  alias GhbotDiscord.Commands.PingCommand
  alias GhbotDiscord.Commands.InstallationsCommand
  alias Nostrum.Api
  alias Nostrum.Struct.Guild
  alias Nostrum.Struct.Interaction

  @message_handlers [
    GhbotDiscord.MessageHandlers.PingHandler
  ]

  @commands %{
    "gh_ping" => PingCommand,
    "gh_bind_installation" => InstallationsCommand
  }

  @select_handlers %{
    "installation_select" => InstallationsCommand
  }

  def start_link do
    Consumer.start_link(__MODULE__)
  end

  def handle_event({:READY, _, _}) do
    {:ok, guilds} = Api.get_current_user_guilds()

    Enum.each(guilds, fn %Guild{id: id} ->
      with {:ok, commands} <- Api.get_guild_application_commands(id) do
        Enum.map(commands, fn %{id: command_id} ->
          Api.delete_guild_application_command(id, command_id)
        end)
      end

      Enum.each(@commands, fn {name, mod} ->
        {status, response} = Api.create_guild_application_command(id, mod.command_definition)

        if status == :error do
          Logger.error("Registering command #{name} failed.")
          Logger.error(inspect(response))
        end
      end)
    end)

    Logger.info("Registered #{Enum.count(@commands)} commands.")
  end

  def handle_event({:INTERACTION_CREATE, %Interaction{data: %{name: name}} = interaction, _}) do
    handler = Map.get(@commands, name)

    if handler do
      handler.handle(interaction)
    else
      :ignore
    end
  end

  def handle_event(
        {:INTERACTION_CREATE,
         %Interaction{data: %{component_type: 3, custom_id: name}} = interaction, _}
      ) do
    handler = Map.get(@select_handlers, name)

    if handler do
      handler.handle_select(interaction)
    else
      :ignore
    end
  end

  def handle_event({:INTERACTION_CREATE, %Interaction{} = interaction, _}) do
    IO.inspect(interaction)
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
