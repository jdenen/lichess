defmodule Mix.Tasks.Recap do
  @moduledoc """
  Summarize the last 100 games of all variants.

  Example:
      mix recap bruce_wayne
  """
  use Mix.Task
  alias Lichex.Config

  @shortdoc "Summarize last 100 games"

  @impl true
  def run(args) do
    args
    |> Enum.at(0, Config.user())
    |> Lichex.summarize()
  end
end
