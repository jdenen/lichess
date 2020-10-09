defmodule Mix.Tasks.Lichess do
  Lichess.Games.games()
  |> Enum.map(fn game ->
    mod_name = Module.concat(__MODULE__, String.capitalize("#{game}"))

    ast =
      quote do
        use Mix.Task

        @shortdoc "#{unquote(game)}"

        @impl true
        def run([username | _]) do
          Lichess.chart_rating(username, unquote(game))
        end
      end

    {mod_name, ast}
  end)
  |> Enum.each(fn {name, ast} ->
    Module.create(name, ast, Macro.Env.location(__ENV__))
  end)
end
