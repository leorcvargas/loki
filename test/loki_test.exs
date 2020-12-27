defmodule LokiTest do
  use ExUnit.Case
  doctest Loki

  test "greets the world" do
    assert Loki.hello() == :world
  end
end
