defmodule GhbotDiscord.Interactions.InstallInteraction do
  @moduledoc """
  Sets up a slash command to perform the first time setup for a guild.
  """

  require Logger

  import GhbotDiscord.Generators.Components

  alias GhbotCore.Github.Installation
  alias GhbotCore.Guild
  alias GhbotDiscord.Interactions.ConfigInteraction
  alias Nostrum.Api
  alias Nostrum.Struct.Interaction
  alias Nostrum.Struct.Guild.Role
  alias Nostrum.Struct.Channel

  # THIS IS A CONSTANT
  def command_name, do: "gh_install"

  def command_definition,
    do: %{
      name: command_name(),
      description: "Setup ghbot. This is required before using any commands.",
      options: []
    }

  def command_version, do: 1

  def handle(%Interaction{} = interaction) do
    guild_id = interaction.guild_id

    # Fetching all of these roles and ids can take a while, so we need
    # to send an ACK and then fill the details in later.
    Api.create_interaction_response(interaction, %{type: 5})

    roles =
      guild_id
      |> Api.get_guild_roles!()
      |> Enum.map(&role_to_option/1)

    channels =
      guild_id
      |> Api.get_guild_channels!()
      # Only keep text channels.
      |> Enum.filter(fn channel -> channel.type == 0 end)
      |> Enum.map(&channel_to_option/1)

    installations =
      Installation.fetch_all!()
      |> Enum.map(&installation_to_option/1)

    {:ok, _} = Guild.create_guild_settings_if_doesnt_exist(guild_id)

    response =
      generate_message(
        "To set up GhBot, fill out the fields below.",
        [
          generate_select(
            ConfigInteraction.admin_role_select_id(),
            "Select an admin role. Certain commands may only be run " <>
              "by a user with the admin role.",
            roles
          ),
          generate_select(
            ConfigInteraction.installation_select_id(),
            "Select the github app installation.",
            installations
          ),
          generate_select(
            ConfigInteraction.notification_channel_select_id(),
            "Select a notification channel. GhBot will put its notifications " <>
              "in this channel. If not present, GhBot will not put any " <>
              "notifications in any channel.",
            channels
          )
        ]
      )

    Logger.info("Interaction: #{interaction.id}, #{interaction.token}")

    webhook_payload = %{
      id: interaction.id,
      token: interaction
    }

    # Followup message doesn't work like interaction response - it
    # expects a map with content in it, so we've got to extract the
    # data from our generated response.
    Api.create_followup_message(interaction.token, response.data)
  end

  defp role_to_option(%Role{} = role) do
    generate_option(role.name, role.id, "")
  end

  defp channel_to_option(%Channel{} = channel) do
    generate_option(channel.name, channel.id, "")
  end

  defp installation_to_option(%Installation{} = installation) do
    generate_option(installation.name, installation.name, "#{installation.type}")
  end
end
