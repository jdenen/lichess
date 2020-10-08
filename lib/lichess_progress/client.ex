defmodule LichessProgress.Client do
  use Tesla

  @token System.fetch_env!("LICHESS_API_TOKEN")

  plug(Tesla.Middleware.BaseUrl, "https://lichess.org/api")
  plug(Tesla.Middleware.Headers, [{"Authorization", "Bearer #{@token}"}])
  plug(Tesla.Middleware.JSON)

  def get_ratings(username, game) do
    with {:ok, resp} <- get("/user/#{username}/rating-history"),
         [game_resp] <- Enum.filter(resp.body, fn %{"name" => name} -> name == game end),
         [_1, _2 | _rest] = ratings <- get_points(game_resp) do
      {:ok, ratings}
    else
      {:error, _} = error -> error
      _ -> {:error, "Insufficient data"}
    end
  end

  defp get_points(game_resp) do
    Map.get(game_resp, "points")
    |> Enum.map(fn [_, _, _, rtg] -> rtg end)
    |> List.flatten()
  end
end
