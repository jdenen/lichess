defmodule Lichess do
  defmodule Games do
    @map %{
      antichess: "Antichess",
      atomic: "Atomic",
      blitz: "Blitz",
      bullet: "Bullet",
      chess960: "Chess960",
      classical: "Classical",
      correspondence: "Correspondence",
      horde: "Horde",
      kingofthehill: "King of the Hill",
      puzzles: "Puzzles",
      racingkings: "Racing Kings",
      rapid: "Rapid",
      threecheck: "Three-check",
      ultrabullet: "UltraBullet"
    }

    @keys Map.keys(@map)
    @values Map.values(@map)

    def validate(game) when game in @keys do
      {:ok, Map.get(@map, game)}
    end

    def validate(game) when game in @values do
      {:ok, game}
    end

    def validate(game) do
      {:error, "Unsupported game type: '#{game}'"}
    end

    def games do
      @keys
    end
  end

  alias Lichess.{Client, Games}

  def chart_rating(username, game) do
    with {:ok, game} <- Games.validate(game),
         {:ok, ratings} <- Client.get_ratings(username, game),
         {:ok, chart} <- Asciichart.plot(ratings, height: 15) do
      IO.puts(chart)
    end
  end
end
