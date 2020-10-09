defmodule Lichess.Client.Games do
  use Tesla

  @token System.fetch_env!("LICHESS_API_TOKEN")

  plug(Tesla.Middleware.BaseUrl, "https://lichess.org/api")

  plug(Tesla.Middleware.Headers, [
    {"Authorization", "Bearer #{@token}"},
    {"Accept", "application/x-ndjson"}
  ])

  def previous(username, n) do
    with {:ok, resp} <- get("/games/user/#{username}?max=#{n}"),
         games when games != [] <- parse_games(resp.body) do
      {:ok, games}
    else
      {:error, _} = error -> error
      _ -> {:error, "Insufficient data"}
    end
  end

  defp parse_games(response) do
    response
    |> String.split("\n", trim: true)
    |> Enum.map(&Jason.decode!/1)
  end
end
