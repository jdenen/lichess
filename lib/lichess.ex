defmodule Lichess do
  alias Lichess.{Client, Summary, Variants}

  def chart_rating(username, variant) do
    with {:ok, variant} <- Variants.validate(variant),
         {:ok, ratings} <- Client.Ratings.history(username, variant),
         {:ok, chart} <- Asciichart.plot(ratings, height: 15) do
      IO.puts(chart)
    end
  end

  def summarize(username) do
    with {:ok, games} <- Client.Games.previous(username, 100) do
      username
      |> Summary.new(games)
      |> IO.puts()
    end
  end
end
