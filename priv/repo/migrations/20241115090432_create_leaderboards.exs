defmodule Leaderboardinator.Repo.Migrations.CreateLeaderboards do
  use Ecto.Migration

  def change do
    create table(:leaderboards) do
      add :title, :string

      timestamps(type: :utc_datetime)
    end
  end
end
