defmodule GhbotCore.Guild.GuildSettings do
  alias GhbotCore.Guild.GuildSettings

  @moduledoc """
  A record to keep track of a guild's settings for the bot.
  """

  use Ecto.Schema
  import Ecto.Changeset

  schema "guild_settings" do
    field :guild_id, :integer
    field :admin_role_id, :integer
    field :installation_id, :string
    field :notification_channel_id, :integer

    timestamps()
  end

  def create_changeset(guild_id) do
    %GuildSettings{}
    |> cast(%{guild_id: guild_id}, [:guild_id])
    |> validate_required([:guild_id])
    |> unsafe_validate_unique(:guild_id, GhbotCore.Repo)
  end

  @doc false
  def changeset(guild_settings, attrs) do
    guild_settings
    |> cast(attrs, [:admin_role_id, :installation_id, :notification_channel_id])
  end

  def strict_changeset(guild_settings) do
    guild_settings
    |> cast(%{}, [])
    |> validate_required([:guild_id, :admin_role_id, :installation_id])
  end
end
