defmodule SimpleGraphqlClient do
  import SimpleGraphqlClient.HttpClient
  import SimpleGraphqlClient.Parser
  import SimpleGraphqlClient.Subscriber
  alias SimpleGraphqlClient.Response

  @moduledoc """
  SimpleGraphqlClient is a graphql client, focused on simplicity and ease of use.

  ## Usage
  ### Query/Mutation example
  ```elixir
  iex>
  query = "query users($name: String){users(name: $name){name}}"
  SimpleGraphqlClient.graphql_request(query, %{name: "Boris"})
  # Will produce
  {:ok,
    %SimpleGraphqlClient.Response{
      body: {:ok, %{"data" => %{"users" => []}}},
      headers: [],
      status_code: 200
    }
  }
  ```

  ### Subscription example
  ```elixir 
  sub_query = "
  subscription testsub {
    userAdded{
      email
    }
  }
  "
  SimpleGraphqlClient.absinthe_subscribe(sub_query, %{}, &IO.inputs/1)

  # Will produce 
  %{"userAdded" => %{"email" => "testuser@example.com"}}
  ```

  ## More examples
  You can find more examples in `test_app/test/graphql` folder

  ## Configuration
  For configuration i suggest to write your own wrappers of &graphql_request/3 or any subscribe function. If you want to pass Authorization parametrs to WS connection, please encode them into url.
  """

  @doc """
   Execute request to graphql endpoint
   * query - any valid graphql query
   * variables -  pass a map with variables to pass alongside with query
   * opts - url and  list of additional headers e.g for authorization

  ## Usage
  ```elixir
    SimpleGraphqlClient.graphql_request(query, %{name: "Boris"}, %{url: "http://example.com/graphql", headers: token: "1234"})
  ```
  """
  @spec graphql_request(binary, map | nil, keyword) ::
          {:ok, Response.t()} | {:error, Response.t() | any}
  def graphql_request(query, variables \\ nil, opts \\ []) do
    query
    |> send_request(variables, opts)
    |> parse_response
  end

  @doc """
    Subcribe to absinthe subscription.
    * query - any vailidd graphql query
    * variables -  pass a map with variables to pass alongside with query
    * callback_or_dest - pass here a callback function or destination to receive message with fulfillment data
    * opts - url and  list of additional headers e.g for authorization

  ## Usage
  ``` 
  SimpleGraphqlClient.absinthe_subscribe(sub_query, %{}, &IO.inputs/1) # Or you can pid/name as last argumen to receive message with fulfillment data
  ```
  """

  @spec absinthe_subscribe(binary, map | nil, keyword) :: :ok | {:error, any}
  def absinthe_subscribe(query, variables, callback_or_dest, opts \\ []) do
    query
    |> absinthe_sub(variables, callback_or_dest, opts)
  end
end
