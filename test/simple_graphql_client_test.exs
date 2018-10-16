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
  subscription name {
    quizFinish{
      id
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
      url = "ws://localhost:4000/socket"
      Application.put_env(:simple_graphql_client, :ws_url, url )
      Application.put_env(:simple_graphql_client, :default_headers, [{"Authorization", "BearereyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJicmFuZF9jaGFsbGVuZ2UiLCJleHAiOjE1NDIxMzg2MTIsImlhdCI6MTUzOTcxOTQxMiwiaXNzIjoiYnJhbmRfY2hhbGxlbmdlIiwianRpIjoiODg5ZGQwOTgtMDg5Ni00OTE0LWJmYzktMGFhYWI4ODRiY2UyIiwibmJmIjoxNTM5NzE5NDExLCJzdWIiOiIyIiwidHlwIjoiYWNjZXNzIn0.JzdrWQuO_UFlCJ52RtmpNgENQR0DivaicpYrb70P66NFdGBhD0nyfKZaSAY9KO4kGP1IC_idf2D7U4CbkDknrg"}])

      {:ok, %{url: url}} 
    end

    test "sub", %{url: url} do
      IO.inspect SimpleGraphqlClient.Supervisor.start_link(url: url)
      IO.inspect SimpleGraphqlClient.subscribe(@sub_query, %{})
    end
  end
end
