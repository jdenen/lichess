defmodule LichessTest do
  use ExUnit.Case
  doctest Lichess

  test "greets the world" do
    assert Lichess.hello() == :world
  end
end
