defmodule SimpleGraphqlClient do
  import SimpleGraphqlClient.HttpClient
  import SimpleGraphqlClient.Parser
  alias SimpleGraphqlClient.Response

  @spec graphql_request(binary, list | nil, map) ::
          {:ok, Response.t()} | {:error, Response.t() | any}
  def graphql_request(query, variables \\ nil, opts \\ %{}) do
    query
    |> send_request(variables, opts)
    |> parse_response
  end
end
