defmodule SimpleGraphqlClientTest do
  use ExUnit.Case
  doctest SimpleGraphqlClient

  test "greets the world" do
    assert SimpleGraphqlClient.hello() == :world
  end
end
