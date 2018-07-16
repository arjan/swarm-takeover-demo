defmodule TakeoverDemoTest do
  use ExUnit.Case
  doctest TakeoverDemo

  test "greets the world" do
    assert TakeoverDemo.hello() == :world
  end
end
