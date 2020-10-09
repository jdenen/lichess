defmodule Lichess.Summary do
  defmodule Category do
    defstruct count: 0, wins: 0

    def new(attrs \\ []) do
      struct(__MODULE__, attrs)
    end

    def inc(%{count: count, wins: wins}, true) do
      new(count: count + 1, wins: wins + 1)
    end

    def inc(%{count: count} = cat, false) do
      %{cat | count: count + 1}
    end
  end

  alias Lichess.Summary.Category

  defstruct black: Category.new(),
            white: Category.new(),
            rated: Category.new(),
            casual: Category.new(),
            blitz: Category.new(),
            rapid: Category.new()

  def new(username, games) when is_list(games) do
    Enum.reduce(games, %__MODULE__{}, &reducer(&1, &2, username))
  end

  defp reducer(game, acc, username) do
    winner? = win?(game, username)

    acc
    |> reduce_color(game, username, winner?)
    |> reduce_speed(game, winner?)
    |> reduce_rated(game, winner?)
  end

  defp reduce_color(
         acc,
         %{"players" => players},
         username,
         winner?
       ) do
    case user_color(players, username) do
      "white" -> %{acc | white: Category.inc(acc.white, winner?)}
      "black" -> %{acc | black: Category.inc(acc.black, winner?)}
    end
  end

  defp reduce_speed(acc, game, winner?) do
    case Map.get(game, "speed") do
      "blitz" -> %{acc | blitz: Category.inc(acc.blitz, winner?)}
      "rapid" -> %{acc | rapid: Category.inc(acc.rapid, winner?)}
      _ -> acc
    end
  end

  defp reduce_rated(acc, game, winner?) do
    case Map.get(game, "rated") do
      true -> %{acc | rated: Category.inc(acc.rated, winner?)}
      false -> %{acc | casual: Category.inc(acc.casual, winner?)}
    end
  end

  defp win?(%{"status" => "draw"}, _), do: false
  defp win?(%{"status" => "stalemate"}, _), do: false

  defp win?(%{"winner" => winner, "players" => players}, username) do
    user_color(players, username) == winner
  end

  defp user_color(players, username) do
    case get_in(players, ["black", "user", "id"]) do
      ^username -> "black"
      _ -> "white"
    end
  end

  defimpl String.Chars do
    def to_string(t) do
      """
      +===========================+
      |  Recap of Last 100 Games  |
      +===========================+
      #{pad_out(t.black, "BLACK")}
      #{pad_out(t.white, "WHITE")}
      +---------------------------+
      #{pad_out(t.rated, "RATED")}
      #{pad_out(t.casual, "CASUAL")}
      +---------------------------+
      #{pad_out(t.blitz, "BLITZ")}
      #{pad_out(t.rapid, "RAPID")}
      +===========================+
      """
    end

    defp pad_out(%{count: count, wins: wins}, label) do
      output = String.pad_trailing("| #{count} #{label} games (#{wins} wins)", 28)
      "#{output}|"
    end
  end
end
