defmodule GhbotDiscord.Migrations do
  require Logger

  alias GhbotCore.Guild
  alias GhbotDiscord.Interactions
  alias Nostrum.Api

  def run(guild_id) do
    {:ok, defined_commands} = Api.get_guild_application_commands(guild_id)
    actual_commands = Interactions.commands()
    processed_commands = MapSet.new()

    Enum.each(defined_commands, fn command ->
      command_name = command.name
      command_module = Map.get(actual_commands, command_name)

      # This is a bit of a head scratcher, but it's required because of
      # Elixir's immutability and scoping rules.
      processed_commands =
        if is_nil(command_module) do
          delete_command(guild_id, command)
          processed_commands
        else
          check_and_update_command(guild_id, command, command_module)
          MapSet.put(processed_commands, command_name)
        end

      commands_to_create =
        Enum.reject(actual_commands, fn command ->
          MapSet.member?(processed_commands, command.name)
        end)

      Enum.each(commands_to_create, fn command ->
        create_command(guild_id, command)
      end)
    end)
  end

  def create_command(guild_id, command_module) do
    command_definition = command_module.command_definition()
    Api.create_guild_application_command(guild_id, command_definition)

    Guild.create_guild_command(%{
      guild_id: guild_id,
      command_name: command_definition.name,
      command_version: command_module.command_version()
    })
  end

  def update_command(guild_id, command, command_module) do
    Api.edit_guild_application_command(
      guild_id,
      command.id,
      command_module.command_definition()
    )

    Guild.update_guild_command_version(
      guild_id,
      command.name,
      command_module.command_version()
    )
  end

  def delete_command(guild_id, command) do
    Api.delete_guild_application_command(guild_id, command.id)
    Guild.delete_guild_command_by_name(guild_id, command.name)
  end

  defp check_and_update_command(guild_id, command, command_module) do
    command_name = command.name
    guild_command = Guild.get_guild_command_by_name(guild_id, command_name)
    actual_version = command_module.version()
    defined_version = guild_command.command_version

    if actual_version != defined_version do
      if actual_version > defined_version do
        Logger.debug(
          "Updating command #{command_name} from version" <>
            " #{defined_version} to #{actual_version}"
        )

        update_command(guild_id, command, command_module)
      else
        Logger.warn(
          "Installed version #{defined_version} of command" <>
            " #{command_name} is greater than version" <>
            " #{actual_version} in module."
        )

        Logger.warn(
          "Making no changes. Please check the version" <>
            "numbers if this is unexpected."
        )
      end
    end
  end
end
