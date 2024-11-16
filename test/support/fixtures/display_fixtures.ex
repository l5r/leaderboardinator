defmodule Leaderboardinator.DisplayFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Leaderboardinator.Display` context.
  """

  @doc """
  Generate a leaderboard.
  """
  def leaderboard_fixture(attrs \\ %{}) do
    {:ok, leaderboard} =
      attrs
      |> Enum.into(%{
        title: "some title"
      })
      |> Leaderboardinator.Display.create_leaderboard()

    leaderboard
  end
end
