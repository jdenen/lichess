defmodule Mix.Tasks.Chart do
  Lichex.Variants.all()
  |> Enum.map(fn variant ->
    mod_name = Module.concat(__MODULE__, String.capitalize("#{variant}"))

    ast =
      quote do
        @moduledoc """
        Chart ratings for #{unquote(variant)}.

        Example:
            mix chart.#{unquote(variant)} bruce_wayne
        """
        use Mix.Task
        alias Lichex.Config

        @shortdoc "Chart ratings for #{unquote(variant)}"

        @impl true
        def run(args) do
          args
          |> Enum.at(0, Config.user())
          |> Lichex.chart_rating(unquote(variant))
        end
      end

    {mod_name, ast}
  end)
  |> Enum.each(fn {name, ast} ->
    Module.create(name, ast, Macro.Env.location(__ENV__))
  end)
end
