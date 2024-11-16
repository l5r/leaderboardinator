defmodule LeaderboardinatorWeb.LeaderboardHTML do
  use LeaderboardinatorWeb, :html

  embed_templates "leaderboard_html/*"

  @doc """
  Renders a leaderboard form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def leaderboard_form(assigns)
end
