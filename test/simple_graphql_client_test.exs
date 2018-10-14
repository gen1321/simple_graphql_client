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

  setup do
    url = "www.example.com/api"
    Application.put_env(:simple_graphql_client, :url, url)

    {:ok, %{url: url}}
  end

  describe "graphql_request/3" do
    test "creates correct request with all parameters passs", %{url: url} do
      with_mock HTTPoison,
        post: fn _api_url, _body, _headers ->
          @mock
        end do
        SimpleGraphqlClient.graphql_request(@query, %{name: "Boris"}, %{headers: [token: "1234"]})

        body =
          "{\"variables\":{\"name\":\"Boris\"},\"query\":\"  query users($name: String){\\n    users(name: $name){\\n      name\\n    }\\n  }\\n\"}"

        headers = [{"Content-Type", "application/json"}, token: "1234"]
        assert_called(HTTPoison.post(url, body, headers))
      end
    end

    test "creates correct request with only a query", %{url: url} do
      with_mock HTTPoison,
        post: fn _api_url, _body, _headers ->
          @mock
        end do
        SimpleGraphqlClient.graphql_request(@query)

        body =
          "{\"query\":\"  query users($name: String){\\n    users(name: $name){\\n      name\\n    }\\n  }\\n\"}"

        headers = [{"Content-Type", "application/json"}]
        assert_called(HTTPoison.post(url, body, headers))
      end
    end

    test "raise if no url" do
      Application.put_env(:simple_graphql_client, :url, nil)

      assert_raise RuntimeError,
                   "Please specify url either in config file or pass it in opts",
                   fn -> SimpleGraphqlClient.graphql_request(@query) end
    end
  end
end
