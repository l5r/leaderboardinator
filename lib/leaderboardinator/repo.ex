defmodule Leaderboardinator.Repo do
  use Ecto.Repo,
    otp_app: :leaderboardinator,
    adapter: Ecto.Adapters.SQLite3
end
