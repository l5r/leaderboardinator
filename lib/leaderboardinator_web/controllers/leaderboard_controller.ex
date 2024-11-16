defmodule LeaderboardinatorWeb.LeaderboardController do
  use LeaderboardinatorWeb, :controller

  alias Leaderboardinator.Display
  alias Leaderboardinator.Display.Leaderboard

  def index(conn, _params) do
    leaderboards = Display.list_leaderboards()
    render(conn, :index, leaderboards: leaderboards)
  end

  def new(conn, _params) do
    changeset = Display.change_leaderboard(%Leaderboard{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"leaderboard" => leaderboard_params}) do
    case Display.create_leaderboard(leaderboard_params) do
      {:ok, leaderboard} ->
        conn
        |> put_flash(:info, "Leaderboard created successfully.")
        |> redirect(to: ~p"/leaderboards/#{leaderboard}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    leaderboard = Display.get_leaderboard!(id)
    render(conn, :show, leaderboard: leaderboard)
  end

  def edit(conn, %{"id" => id}) do
    leaderboard = Display.get_leaderboard!(id)
    changeset = Display.change_leaderboard(leaderboard)
    render(conn, :edit, leaderboard: leaderboard, changeset: changeset)
  end

  def update(conn, %{"id" => id, "leaderboard" => leaderboard_params}) do
    leaderboard = Display.get_leaderboard!(id)

    case Display.update_leaderboard(leaderboard, leaderboard_params) do
      {:ok, leaderboard} ->
        conn
        |> put_flash(:info, "Leaderboard updated successfully.")
        |> redirect(to: ~p"/leaderboards/#{leaderboard}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, leaderboard: leaderboard, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    leaderboard = Display.get_leaderboard!(id)
    {:ok, _leaderboard} = Display.delete_leaderboard(leaderboard)

    conn
    |> put_flash(:info, "Leaderboard deleted successfully.")
    |> redirect(to: ~p"/leaderboards")
  end
end
