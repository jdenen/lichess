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
            rapid: Category.new(),
            correspondence: Category.new(),
            classic: Category.new()

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

  defp reduce_speed(acc, %{"speed" => "blitz"}, winner?) do
    %{acc | blitz: Category.inc(acc.blitz, winner?)}
  end

  defp reduce_speed(acc, %{"speed" => "rapid"}, winner?) do
    %{acc | rapid: Category.inc(acc.rapid, winner?)}
  end

  defp reduce_speed(acc, %{"speed" => "correspondence"}, winner?) do
    %{acc | correspondence: Category.inc(acc.correspondence, winner?)}
  end

  defp reduce_speed(acc, %{"speed" => "classical"}, winner?) do
    %{acc | classic: Category.inc(acc.classic, winner?)}
  end

  defp reduce_rated(acc, %{"rated" => true}, winner?) do
    %{acc | rated: Category.inc(acc.rated, winner?)}
  end

  defp reduce_rated(acc, %{"rated" => false}, winner?) do
    %{acc | casual: Category.inc(acc.casual, winner?)}
  end

  defp win?(%{"winner" => winner, "players" => players}, username) do
    user_color(players, username) == winner
  end

  defp user_color(players, username) do
    case get_in(players, ["black", "user", "id"]) do
      ^username -> "black"
      _ -> "white"
    end
  end
end
