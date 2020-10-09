defmodule Lichess do
  alias Lichess.{Client, Variants}

  def chart_rating(username, game) do
    with {:ok, game} <- Variants.validate(game),
         {:ok, ratings} <- Client.Ratings.history(username, game),
         {:ok, chart} <- Asciichart.plot(ratings, height: 15) do
      IO.puts(chart)
    end
  end
end
