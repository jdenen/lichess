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

    @atoms Map.keys(@map)
    @strings Map.values(@map)

    def parse(game) when is_atom(game) and game in @atoms do
      {:ok, Map.get(@map, game)}
    end

    def parse(game) when is_binary(game) and game in @strings do
      {:ok, game}
    end

    def parse(game) when is_binary(game) do
      game_atom =
        game
        |> String.replace(~r/[-_\s]/, "")
        |> String.downcase()
        |> String.to_existing_atom()

      parse(game_atom)
    rescue
      ArgumentError -> {:error, "Unsupported game type: '#{game}'"}
    end
  end

  alias Lichess.{Client, Games}

  def chart_rating(username, game) do
    with {:ok, game} <- Games.parse(game),
         {:ok, ratings} <- Client.get_ratings(username, game),
         {:ok, chart} <- Asciichart.plot(ratings, height: 15) do
      IO.puts(chart)
    end
  end
end
