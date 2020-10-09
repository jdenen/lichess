defmodule Mix.Tasks.Lichess do
  Lichess.Variants.all()
  |> Enum.map(fn variant ->
    mod_name = Module.concat(__MODULE__, String.capitalize("#{variant}"))

    ast =
      quote do
        @moduledoc """
        Chart ratings for #{unquote(variant)}.

        Example:
            mix lichess.#{unquote(variant)} bruce_wayne
        """
        use Mix.Task
        alias Lichess.Config

        @shortdoc "Chart ratings for #{unquote(variant)}"

        @impl true
        def run(args) do
          args
          |> Enum.at(0, Config.user())
          |> Lichess.chart_rating(unquote(variant))
        end
      end

    {mod_name, ast}
  end)
  |> Enum.each(fn {name, ast} ->
    Module.create(name, ast, Macro.Env.location(__ENV__))
  end)

  defmodule Recap do
    @moduledoc """
    Summarize the last 100 games of all variants.

    Example:
        mix lichess.recap bruce_wayne
    """
    use Mix.Task
    alias Lichess.Config

    @shortdoc "Summarize last 100 games"

    @impl true
    def run(args) do
      args
      |> Enum.at(0, Config.user())
      |> Lichess.summarize()
    end
  end
end
