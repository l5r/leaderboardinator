defmodule LeaderboardinatorWeb.LeaderboardLiveTest do
  use LeaderboardinatorWeb.ConnCase

  import Phoenix.LiveViewTest
  import Leaderboardinator.DisplayFixtures

  @create_attrs %{title: "some title"}
  @update_attrs %{title: "some updated title"}
  @invalid_attrs %{title: nil}

  defp create_leaderboard(_) do
    leaderboard = leaderboard_fixture()
    %{leaderboard: leaderboard}
  end

  describe "Index" do
    setup [:create_leaderboard]

    test "lists all leaderboards", %{conn: conn, leaderboard: leaderboard} do
      {:ok, _index_live, html} = live(conn, ~p"/leaderboards")

      assert html =~ "Listing Leaderboards"
      assert html =~ leaderboard.title
    end

    test "saves new leaderboard", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/leaderboards")

      assert index_live |> element("a", "New Leaderboard") |> render_click() =~
               "New Leaderboard"

      assert_patch(index_live, ~p"/leaderboards/new")

      assert index_live
             |> form("#leaderboard-form", leaderboard: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#leaderboard-form", leaderboard: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/leaderboards")

      html = render(index_live)
      assert html =~ "Leaderboard created successfully"
      assert html =~ "some title"
    end

    test "updates leaderboard in listing", %{conn: conn, leaderboard: leaderboard} do
      {:ok, index_live, _html} = live(conn, ~p"/leaderboards")

      assert index_live |> element("#leaderboards-#{leaderboard.id} a", "Edit") |> render_click() =~
               "Edit Leaderboard"

      assert_patch(index_live, ~p"/leaderboards/#{leaderboard}/edit")

      assert index_live
             |> form("#leaderboard-form", leaderboard: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#leaderboard-form", leaderboard: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/leaderboards")

      html = render(index_live)
      assert html =~ "Leaderboard updated successfully"
      assert html =~ "some updated title"
    end

    test "deletes leaderboard in listing", %{conn: conn, leaderboard: leaderboard} do
      {:ok, index_live, _html} = live(conn, ~p"/leaderboards")

      assert index_live |> element("#leaderboards-#{leaderboard.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#leaderboards-#{leaderboard.id}")
    end
  end

  describe "Show" do
    setup [:create_leaderboard]

    test "displays leaderboard", %{conn: conn, leaderboard: leaderboard} do
      {:ok, _show_live, html} = live(conn, ~p"/leaderboards/#{leaderboard}")

      assert html =~ "Show Leaderboard"
      assert html =~ leaderboard.title
    end

    test "updates leaderboard within modal", %{conn: conn, leaderboard: leaderboard} do
      {:ok, show_live, _html} = live(conn, ~p"/leaderboards/#{leaderboard}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Leaderboard"

      assert_patch(show_live, ~p"/leaderboards/#{leaderboard}/show/edit")

      assert show_live
             |> form("#leaderboard-form", leaderboard: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#leaderboard-form", leaderboard: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/leaderboards/#{leaderboard}")

      html = render(show_live)
      assert html =~ "Leaderboard updated successfully"
      assert html =~ "some updated title"
    end
  end
end
