defmodule GhbotDiscord.Interactions.ConfigInteraction do
  require Logger

  import GhbotDiscord.Generators.Components

  alias GhbotCore.Guild
  alias Nostrum.Api
  alias Nostrum.Struct.Interaction

  def command_name, do: "gh_config"

  def command_definition,
    do: %{
      name: command_name(),
      description: "Configure GhBot's settings for this guild.",
      options: []
    }

  def command_version, do: 1
  @admin_role_select_id "gh_config_admin_role"
  def admin_role_select_id, do: @admin_role_select_id
  @installation_select_id "gh_config_installation"
  def installation_select_id, do: @installation_select_id
  @notification_channel_select_id "gh_config_notification_channel"
  def notification_channel_select_id, do: @notification_channel_select_id

  def select_ids,
    do: [
      @admin_role_select_id,
      @installation_select_id,
      @notification_channel_select_id
    ]

  def handle(
        %Interaction{data: %{custom_id: @admin_role_select_id, values: [admin_role_id | _]}} =
          interaction
      ) do
    Guild.update_guild_settings_admin_role_id(interaction.guild_id, admin_role_id)
    response = generate_message("Successfully set admin role to role with id #{admin_role_id}.")
    Api.create_interaction_response(interaction, response)
  end

  def handle(
        %Interaction{data: %{custom_id: @installation_select_id, values: [installation_id | _]}} =
          interaction
      ) do
    Guild.update_guild_settings_installation_id(interaction.guild_id, installation_id)
    response = generate_message("Successfully set installation to id #{installation_id}.")
    Api.create_interaction_response(interaction, response)
  end

  def handle(
        %Interaction{
          data: %{
            custom_id: @notification_channel_select_id,
            values: [notification_channel_id | _]
          }
        } = interaction
      ) do
    Guild.update_guild_settings_notification_channel_id(
      interaction.guild_id,
      notification_channel_id
    )

    response =
      generate_message(
        "Successfully set notification channel to channel with id " <>
          to_string(notification_channel_id)
      )

    Api.create_interaction_response(interaction, response)
  end
end
