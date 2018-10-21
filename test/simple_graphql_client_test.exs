defmodule SimpleGraphqlClientTest do
  use ExUnit.Case

  import Mock
  alias SimpleGraphqlClient

  doctest SimpleGraphqlClient

  @query """
    query users($name: String){
      users(name: $name){
        name
      }
    }
  """

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

  @mock {:ok,
         %{
           body: """
           {
             "data": {
               "users": []
             }
           }
           """,
           status_code: 200,
           headers: []
         }}

  describe "graphql_request/3" do
    setup do
      url = "www.example.com/api"
      Application.put_env(:simple_graphql_client, :url, url)

      {:ok, %{url: url}}
    end

    test "creates correct request with all parameters passs", %{url: url} do
      with_mock HTTPoison,
        post: fn _api_url, _body, _headers ->
          @mock
        end do
        resp =
          SimpleGraphqlClient.graphql_request(@query, %{name: "Boris"}, %{
            headers: [token: "1234"]
          })

        body =
          "{\"variables\":{\"name\":\"Boris\"},\"query\":\"  query users($name: String){\\n    users(name: $name){\\n      name\\n    }\\n  }\\n\"}"

        headers = [{"Content-Type", "application/json"}, token: "1234"]
        assert_called(HTTPoison.post(url, body, headers))

        assert {:ok,
                %SimpleGraphqlClient.Response{
                  body: {:ok, %{"data" => %{"users" => []}}},
                  headers: [],
                  status_code: 200
                }} == resp
      end
    end

    test "creates correct request with only a query", %{url: url} do
      with_mock HTTPoison,
        post: fn _api_url, _body, _headers ->
          @mock
        end do
        resp = SimpleGraphqlClient.graphql_request(@query)

        body =
          "{\"query\":\"  query users($name: String){\\n    users(name: $name){\\n      name\\n    }\\n  }\\n\"}"

        headers = [{"Content-Type", "application/json"}]
        assert_called(HTTPoison.post(url, body, headers))

        assert {:ok,
                %SimpleGraphqlClient.Response{
                  body: {:ok, %{"data" => %{"users" => []}}},
                  headers: [],
                  status_code: 200
                }} == resp
      end
    end

    test "raise if no url" do
      Application.put_env(:simple_graphql_client, :url, nil)

      assert_raise RuntimeError,
                   "Please specify url either in config file or pass it in opts",
                   fn -> SimpleGraphqlClient.graphql_request(@query) end
    end
  end

  describe "subscribe/4" do
    setup do
      ws_url = "ws://localhost:4000/socket/websocket"
      url = "http://localhost:4000/api"
      Application.put_env(:simple_graphql_client, :ws_url, url)
      Application.put_env(:simple_graphql_client, :url, url)

      {:ok, %{ws_url: ws_url, url: url}}
    end

    test "subscribe with dest", %{ws_url: ws_url} do
      SimpleGraphqlClient.Supervisor.start_link(url: ws_url)
      :timer.sleep(50)
      SimpleGraphqlClient.absinthe_subscribe(@sub_query, %{}, self())
      :timer.sleep(50)
      SimpleGraphqlClient.graphql_request(@mutation_query)
      :timer.sleep(50)
      assert_received %{"userAdded" => %{"email" => "testuser@example.com"}}
    end

    test "subscribe with callback", %{ws_url: ws_url} do
      SimpleGraphqlClient.Supervisor.start_link(url: ws_url)
      :timer.sleep(50)
      SimpleGraphqlClient.absinthe_subscribe(@sub_query, %{}, fn data ->
        assert data == %{"userAdded" => %{"email" => "testuser@example.com"}}
      end)
      :timer.sleep(50)
      SimpleGraphqlClient.graphql_request(@mutation_query)
      :timer.sleep(50)
    end
  end
end
