defmodule LeaderboardinatorWeb.LeaderboardLive.Show do
alias LeaderboardinatorWeb.LeaderboardLive
  use LeaderboardinatorWeb, :live_view

  alias Leaderboardinator.Display

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    Phoenix.PubSub.subscribe(Leaderboardinator.PubSub, "leaderboard:#{id}")
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    show_leaderboard(id,socket)
  end

  @impl true
  def handle_info({LeaderboardLive, :change, leaderboard}, socket) do
  	show_leaderboard(leaderboard.id, socket)
  end

  defp show_leaderboard(id, socket) do
    leaderboard =  Display.get_leaderboard!(id)
    max_score = leaderboard.contestants
      |> Enum.map(fn c -> c.score end)
      |> Enum.max()

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:leaderboard, leaderboard)
     |> assign(:max_score, max_score)}
  end

  defp page_title(:show), do: "Show Leaderboard"
  defp page_title(:edit), do: "Edit Leaderboard"
end
