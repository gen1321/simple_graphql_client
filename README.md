# SimpleGraphqlClient
Simple Graphql client for elixir!

## Why
Q: There is a lot of others GraphQL clients for elixir, why creating another one.

A: Because some of them wants you to interpolate variables directly into your query string, and IMHO that is not best approach, some of them are too complicated for just pick them up. And some of them extremely cool like Maple but do not fit into general usage.

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

## Installation
```elixir
def deps do
  [
    {:simple_graphql_client, "~> 0.2.0"}
  ]
end
```

## Roadmap
  * Add support for subscribtion(50% done, absinthe subscriptions already here)
  * Better Dialyzer
  * CI/Test coverege
  
 PRs are WELCOME

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/simple_graphql_client](https://hexdocs.pm/simple_graphql_client).

