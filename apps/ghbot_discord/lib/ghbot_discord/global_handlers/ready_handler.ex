defmodule GhbotDiscord.GlobalHandlers.ReadyHandler do
  @moduledoc """
  Runs the boot-time setup for the bot.
  """

  alias GhbotCore.Guild
  alias GhbotDiscord.Migrations
  alias GhbotDiscord.Setup
  alias Nostrum.Api

  def handle() do
    {:ok, guilds} = Api.get_current_user_guilds()

    Enum.each(guilds, fn guild ->
      guild_id = to_string(guild.id)

      if Guild.guild_ready?(guild_id) do
        Migrations.run(guild_id)
      else
        Setup.run(guild_id)
      end
    end)
  end
end
