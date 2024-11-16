defmodule Leaderboardinator.Display.Leaderboard do
  alias Leaderboardinator.Display.Contestant
  use Ecto.Schema
  import Ecto.Changeset

  schema "leaderboards" do
    field :title, :string

    has_many :contestants, Contestant, on_replace: :delete

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(leaderboard, attrs) do
    leaderboard
    |> cast(attrs, [:title])
    |> cast_assoc(:contestants,
      with: &Contestant.changeset/2,
      sort_param: :contestants_sort,
      drop_param: :contestants_drop
    )
    |> validate_required([:title])
  end
end
