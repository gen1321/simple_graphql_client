defmodule AbsintheTestApp.SubscriptionTest do
  use ExUnit.Case

  @sub_query """
  subscription testsub {
    userAdded{
      email
     }
  }
  """

  @mutation_query """
  mutation testmut {
    createUser(email: "testuser@example.com", name: "testname"){
      email
    }
  }
  """

  @opts [url: "http://localhost:4000/api"]
  test "subscribe with dest" do
    SimpleGraphqlClient.absinthe_subscribe(@sub_query, %{}, self())
    SimpleGraphqlClient.graphql_request(@mutation_query, %{}, @opts)
    assert_received %{"userAdded" => %{"email" => "testuser@example.com"}}
  end

  test "subscribe with callback" do
    SimpleGraphqlClient.absinthe_subscribe(@sub_query, %{}, fn data ->
      assert data == %{"userAdded" => %{"email" => "testuser@example.com"}}
    end)

    SimpleGraphqlClient.graphql_request(@mutation_query, %{}, @opts)
  end
end
