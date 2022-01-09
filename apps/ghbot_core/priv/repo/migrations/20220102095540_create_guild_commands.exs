defmodule GhbotCore.Repo.Migrations.CreateGuildCommands do
  use Ecto.Migration

  def change do
    create table(:guild_commands) do
      add :guild_id, :string, null: false
      add :command_name, :string, null: false
      add :command_version, :integer, null: false

      timestamps()
    end

    create index(:guild_commands, [:guild_id, :command_name], unique: true)
  end
end
