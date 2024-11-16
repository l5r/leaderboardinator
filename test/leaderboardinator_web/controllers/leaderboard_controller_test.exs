defmodule LeaderboardinatorWeb.LeaderboardControllerTest do
  use LeaderboardinatorWeb.ConnCase

  import Leaderboardinator.DisplayFixtures

  @create_attrs %{title: "some title"}
  @update_attrs %{title: "some updated title"}
  @invalid_attrs %{title: nil}

  describe "index" do
    test "lists all leaderboards", %{conn: conn} do
      conn = get(conn, ~p"/leaderboards")
      assert html_response(conn, 200) =~ "Listing Leaderboards"
    end
  end

  describe "new leaderboard" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/leaderboards/new")
      assert html_response(conn, 200) =~ "New Leaderboard"
    end
  end

  describe "create leaderboard" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/leaderboards", leaderboard: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/leaderboards/#{id}"

      conn = get(conn, ~p"/leaderboards/#{id}")
      assert html_response(conn, 200) =~ "Leaderboard #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/leaderboards", leaderboard: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Leaderboard"
    end
  end

  describe "edit leaderboard" do
    setup [:create_leaderboard]

    test "renders form for editing chosen leaderboard", %{conn: conn, leaderboard: leaderboard} do
      conn = get(conn, ~p"/leaderboards/#{leaderboard}/edit")
      assert html_response(conn, 200) =~ "Edit Leaderboard"
    end
  end

  describe "update leaderboard" do
    setup [:create_leaderboard]

    test "redirects when data is valid", %{conn: conn, leaderboard: leaderboard} do
      conn = put(conn, ~p"/leaderboards/#{leaderboard}", leaderboard: @update_attrs)
      assert redirected_to(conn) == ~p"/leaderboards/#{leaderboard}"

      conn = get(conn, ~p"/leaderboards/#{leaderboard}")
      assert html_response(conn, 200) =~ "some updated title"
    end

    test "renders errors when data is invalid", %{conn: conn, leaderboard: leaderboard} do
      conn = put(conn, ~p"/leaderboards/#{leaderboard}", leaderboard: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Leaderboard"
    end
  end

  describe "delete leaderboard" do
    setup [:create_leaderboard]

    test "deletes chosen leaderboard", %{conn: conn, leaderboard: leaderboard} do
      conn = delete(conn, ~p"/leaderboards/#{leaderboard}")
      assert redirected_to(conn) == ~p"/leaderboards"

      assert_error_sent 404, fn ->
        get(conn, ~p"/leaderboards/#{leaderboard}")
      end
    end
  end

  defp create_leaderboard(_) do
    leaderboard = leaderboard_fixture()
    %{leaderboard: leaderboard}
  end
end
