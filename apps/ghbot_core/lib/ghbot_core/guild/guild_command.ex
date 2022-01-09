defmodule GhbotCore.Guild.GuildCommand do
  use Ecto.Schema
  import Ecto.Changeset

  schema "guild_commands" do
    field :command_name, :string
    field :command_version, :integer
    field :guild_id, :string

    timestamps()
  end

  @doc false
  def changeset(guild_command, attrs) do
    guild_command
    |> cast(attrs, [:guild_id, :command_name, :command_version])
    |> validate_required([:guild_id, :command_name, :command_version])
    |> unsafe_validate_unique([:guild_id, :command_name], GhbotCore.Repo)
  end
end
