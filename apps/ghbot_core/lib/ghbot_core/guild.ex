defmodule GhbotCore.Guild do
  import Ecto.Query, warn: false

  alias GhbotCore.Repo
  alias GhbotCore.Guild.GuildCommand
  alias GhbotCore.Guild.GuildSettings

  def get_guild_settings_by_guild_id(guild_id) do
    Repo.get_by(GuildSettings, guild_id: guild_id)
  end

  def guild_ready?(%GuildSettings{} = settings) do
    changeset = GuildSettings.strict_changeset(settings)

    if changeset.valid? do
      true
    else
      false
    end
  end

  def guild_ready?(guild_id) do
    settings = get_guild_settings_by_guild_id(guild_id)

    if settings do
      guild_ready?(settings)
    else
      false
    end
  end

  def get_guild_commands_by_guild_id(guild_id) do
    GuildCommand
    |> where(guild_id: ^guild_id)
    |> Repo.all()
  end

  def get_guild_command_by_name(guild_id, name) do
    Repo.get_by(GuildCommand, guild_id: guild_id, command_name: name)
  end

  def delete_guild_command_by_name(guild_id, name) do
    GuildCommand
    |> where(guild_id: ^guild_id, command_name: ^name)
    |> Repo.delete_all()
  end

  def create_guild_command(%{} = guild_command) do
    %GuildCommand{}
    |> GuildCommand.changeset(guild_command)
    |> Repo.insert()
  end

  def update_guild_command_version(guild_id, name, command_version) do
    guild_id
    |> get_guild_command_by_name(name)
    |> GuildCommand.changeset(%{command_version: command_version})
    |> Repo.update()
  end

  def update_guild_settings_admin_role_id(guild_id, admin_role_id) do
    guild_id
    |> get_guild_settings_by_guild_id()
    |> GuildSettings.changeset(%{admin_role_id: admin_role_id})
    |> Repo.update()
  end

  def update_guild_settings_installation_id(guild_id, installation_id) do
    guild_id
    |> get_guild_settings_by_guild_id()
    |> GuildSettings.changeset(%{installation_id: installation_id})
    |> Repo.update()
  end

  def update_guild_settings_notification_channel_id(guild_id, notification_channel_id) do
    guild_id
    |> get_guild_settings_by_guild_id()
    |> GuildSettings.changeset(%{notification_channel_id: notification_channel_id})
    |> Repo.update()
  end

  def create_guild_settings(guild_id) do
    guild_id
    |> GuildSettings.create_changeset()
    |> Repo.insert()
  end

  def create_guild_settings_if_doesnt_exist(guild_id) do
    settings = get_guild_settings_by_guild_id(guild_id)

    if settings do
      {:ok, settings}
    else
      create_guild_settings(guild_id)
    end
  end
end
