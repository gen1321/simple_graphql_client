defmodule SimpleGraphqlClient do
  @moduledoc """
  SimpleGraphqlClient is a graphql client, focused on simplicity and ease of use.

  ## Usage
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
  If you planning to use it only against single endpoint i suggest you to config it in config.exs
  ```elixir
  config :simple_graphql_client, url: "http://example.com/graphql"
  ```
  """
  import SimpleGraphqlClient.HttpClient
  import SimpleGraphqlClient.Parser
  alias SimpleGraphqlClient.Response

  @doc """
   Execute request to graphql endpoint
   * query - any valid graphql query
   * variables -  pass a map with variables to pass alongside with query
   * opts - supports overiding url with :url key and passing list of additional headers e.g for authorization

  ## Usage
  ```elixir
    SimpleGraphqlClient.graphql_request(query, %{name: "Boris"}, %{url: "http://example.com/graphql", headers: token: "1234"})
  ```
  """
  @spec graphql_request(binary, map | nil, map) ::
          {:ok, Response.t()} | {:error, Response.t() | any}
  def graphql_request(query, variables \\ nil, opts \\ %{}) do
    query
    |> send_request(variables, opts)
    |> parse_response
  end
end
