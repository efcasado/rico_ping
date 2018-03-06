defmodule RicopingTest do
  use ExUnit.Case
  doctest Ricoping

  test "greets the world" do
    assert Ricoping.hello() == :world
  end
end
