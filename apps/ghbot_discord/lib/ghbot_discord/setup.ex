defmodule GhbotDiscord.Setup do
  require Logger

  alias GhbotDiscord.Migrations
  alias Nostrum.Api

  @install_command_module GhbotDiscord.Interactions.InstallInteraction

  def run(guild_id) do
    Logger.info("Running first-time setup for guild id #{guild_id}.")
    delete_superfluous_commands(guild_id)
    create_install_command(guild_id)
    Logger.info("First-time setup completed for guild id #{guild_id}.")
  end

  defp delete_superfluous_commands(guild_id) do
    {:ok, commands} = Api.get_guild_application_commands(guild_id)

    Enum.each(commands, fn command ->
      Migrations.delete_command(guild_id, command)
    end)
  end

  defp create_install_command(guild_id) do
    Api.create_guild_application_command(guild_id, @install_command_module.command_definition)
  end
end
