defmodule Leaderboardinator.Display.Contestant do
  use Ecto.Schema
  import Ecto.Changeset

  schema "contestants" do
    field :name, :string
    field :score, :integer
    field :leaderboard_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(contestant, attrs) do
    contestant
    |> cast(attrs, [:name, :score, :leaderboard_id])
  end
end
