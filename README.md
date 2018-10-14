# SimpleGraphqlClient
Simple Graphql client for elixir!

## Why
Q: There is a lot of others GraphQL clients for elixir, why creating another one.

A: Because some of them wants you to interpolate variables directly into your query string, and IMHO that is not best approach, some of them are too complicated for just pick them up. And some of them extremely cool like Maple but do not fit into general usage.

## Usage

```elixir
iex>
  query = "query users($name: String){users(name: $name){name}}
  SimpleGraphqlClient.graphql_request(query, %{name: "Boris"})
  # Will produce
  {:ok,
  %SimpleGraphqlClient.Response{
    body: {:ok, %{"data" => %{"users" => []}}},
    headers: [],
    status_code: 200
   }}
```

## Configuration
If you planning to use it only against single endpoint i suggest you to config it in config.exs
```elixir
config :simple_graphql_client, url: "http://example.com/graphql"
```

## Installation
```elixir
def deps do
  [
    {:simple_graphql_client, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/simple_graphql_client](https://hexdocs.pm/simple_graphql_client).

