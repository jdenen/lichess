defmodule Lichex.Config do
  def user do
    System.get_env("LICHESS_DEFAULT_USER")
  end

  def token do
    System.get_env("LICHESS_API_TOKEN")
  end
end
