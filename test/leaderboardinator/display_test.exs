defmodule Leaderboardinator.DisplayTest do
  use Leaderboardinator.DataCase

  alias Leaderboardinator.Display

  describe "leaderboards" do
    alias Leaderboardinator.Display.Leaderboard

    import Leaderboardinator.DisplayFixtures

    @invalid_attrs %{title: nil}

    test "list_leaderboards/0 returns all leaderboards" do
      leaderboard = leaderboard_fixture()
      assert Display.list_leaderboards() == [leaderboard]
    end

    test "get_leaderboard!/1 returns the leaderboard with given id" do
      leaderboard = leaderboard_fixture()
      assert Display.get_leaderboard!(leaderboard.id) == leaderboard
    end

    test "create_leaderboard/1 with valid data creates a leaderboard" do
      valid_attrs = %{title: "some title"}

      assert {:ok, %Leaderboard{} = leaderboard} = Display.create_leaderboard(valid_attrs)
      assert leaderboard.title == "some title"
    end

    test "create_leaderboard/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Display.create_leaderboard(@invalid_attrs)
    end

    test "update_leaderboard/2 with valid data updates the leaderboard" do
      leaderboard = leaderboard_fixture()
      update_attrs = %{title: "some updated title"}

      assert {:ok, %Leaderboard{} = leaderboard} = Display.update_leaderboard(leaderboard, update_attrs)
      assert leaderboard.title == "some updated title"
    end

    test "update_leaderboard/2 with invalid data returns error changeset" do
      leaderboard = leaderboard_fixture()
      assert {:error, %Ecto.Changeset{}} = Display.update_leaderboard(leaderboard, @invalid_attrs)
      assert leaderboard == Display.get_leaderboard!(leaderboard.id)
    end

    test "delete_leaderboard/1 deletes the leaderboard" do
      leaderboard = leaderboard_fixture()
      assert {:ok, %Leaderboard{}} = Display.delete_leaderboard(leaderboard)
      assert_raise Ecto.NoResultsError, fn -> Display.get_leaderboard!(leaderboard.id) end
    end

    test "change_leaderboard/1 returns a leaderboard changeset" do
      leaderboard = leaderboard_fixture()
      assert %Ecto.Changeset{} = Display.change_leaderboard(leaderboard)
    end
  end
end
