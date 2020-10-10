defmodule Mix.Tasks.Recap do
  @moduledoc """
  Summarize the last 100 games of all variants.

  Example:
      mix recap bruce_wayne

      mix recap --count 42 bruce_wayne
  """
  use Mix.Task
  alias Lichex.Config

  @shortdoc "Summarize recent games"

  @impl true
  def run(args) do
    {flags, args, _} = OptionParser.parse(args, strict: [count: :integer])

    count = Keyword.get(flags, :count, 100)
    username = Enum.at(args, 0, Config.user())

    Lichex.summarize(username, count)
  end
end
