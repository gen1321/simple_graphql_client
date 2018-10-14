defmodule SimpleGraphqlClient.HttpClient do
  @moduledoc """
    This module handles all http stuff
  """

  def send_request(query, variables \\ nil, opts \\ %{}) do
    HTTPoison.post(api_url(opts), body(query, variables), headers(opts))
  end

  defp body(query, variables) do
    query
    |> create_body(variables)
    |> Poison.encode!()
  end

  defp create_body(query, nil) do
    %{query: query}
  end

  defp create_body(query, %{} = variables) do
    %{query: query, variables: variables}
  end

  defp api_url(opts) do
    url = Map.get(opts, :url) || Application.get_env(:simple_graphql_client, :url)

    if url == nil do
      raise "Please specify url either in config file or pass it in opts"
    end

    url
  end

  defp headers(opts) do
    custom_headers =
      Map.get(opts, :headers) || Application.get_env(:simple_graphql_client, :default_headers) ||
        []

    graphql_headers() ++ custom_headers
  end

  defp graphql_headers do
    [{"Content-Type", "application/json"}]
  end
end
