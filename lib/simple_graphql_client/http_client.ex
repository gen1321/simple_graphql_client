defmodule SimpleGraphqlClient.HttpClient do
  import SimpleGraphqlClient.Config

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
end
