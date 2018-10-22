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
      {:ok, %{url: "www.example.com/api"}}
    end

    test "creates correct request with all parameters passs", %{url: url} do
      with_mock HTTPoison,
        post: fn _api_url, _body, _headers ->
          @mock
        end do
        resp =
          SimpleGraphqlClient.graphql_request(@query, %{name: "Boris"}, headers: [token: "1234"], url: url)

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
        resp = SimpleGraphqlClient.graphql_request(@query, nil, [url: url])

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
      assert_raise RuntimeError,
        "Please pass url it in opts",
                   fn -> SimpleGraphqlClient.graphql_request(@query) end
    end
  end
end
