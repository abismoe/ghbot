defmodule GhbotCore.Repo.Migrations.CreateSettings do
  use Ecto.Migration

  def change do
    create table(:guild_settings) do
      add :guild_id, :integer, null: false
      add :admin_role_id, :integer
      add :installation_id, :string
      add :notification_channel_id, :integer

      timestamps()
    end

    create index(:guild_settings, :guild_id, unique: true)
  end
end
