defmodule Mix.Tasks.Lichess do
  Lichess.Variants.all()
  |> Enum.map(fn variant ->
    mod_name = Module.concat(__MODULE__, String.capitalize("#{variant}"))

    ast =
      quote do
        @moduledoc """
        Chart ratings for #{unquote(variant)}. Username argument required.

        Example:
            mix lichess.#{unquote(variant)} bruce_wayne
        """
        use Mix.Task

        @shortdoc "Chart ratings for #{unquote(variant)}"

        @impl true
        def run([username | _]) do
          Lichess.chart_rating(username, unquote(variant))
        end
      end

    {mod_name, ast}
  end)
  |> Enum.each(fn {name, ast} ->
    Module.create(name, ast, Macro.Env.location(__ENV__))
  end)

  defmodule Summary do
    @moduledoc """
    Summarize the last 100 games of all variants. Username argument required.

    Example:
        mix lichess.summary bruce_wayne
    """
    use Mix.Task

    @shortdoc "Summarize last 100 games"

    @impl true
    def run([username | _]) do
      Lichess.summarize(username)
    end
  end
end
