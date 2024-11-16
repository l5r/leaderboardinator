defmodule LeaderboardinatorWeb.LeaderboardLive.Index do
  use LeaderboardinatorWeb, :live_view

  alias Leaderboardinator.Display
  alias Leaderboardinator.Display.Leaderboard

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :leaderboards, Display.list_leaderboards())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Leaderboard")
    |> assign(:leaderboard, Display.get_leaderboard!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Leaderboard")
    |> assign(:leaderboard, %Leaderboard{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Leaderboards")
    |> assign(:leaderboard, nil)
  end

  @impl true
  def handle_info({LeaderboardinatorWeb.LeaderboardLive.FormComponent, {:saved, leaderboard}}, socket) do
    {:noreply, stream_insert(socket, :leaderboards, leaderboard)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    leaderboard = Display.get_leaderboard!(id)
    {:ok, _} = Display.delete_leaderboard(leaderboard)

    {:noreply, stream_delete(socket, :leaderboards, leaderboard)}
  end
end
