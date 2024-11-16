defmodule Leaderboardinator.Repo.Migrations.CreateContestants do
  use Ecto.Migration

  def change do
    create table(:contestants) do
      add :name, :string
      add :score, :integer
      add :leaderboard_id, references(:leaderboards, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:contestants, [:leaderboard_id])
  end
end
