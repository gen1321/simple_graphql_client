defmodule SimpleGraphqlClient.Config do
  @default_headers [{"Content-Type", "application/json"}]
  def api_url(opts) do
    required_url(opts, :url)
  end

  def ws_api_url(opts) do
    required_url(opts, :ws_url)
  end

  def headers(opts) do
    @default_headers ++
      (Map.get(opts, :headers) || Application.get_env(:simple_graphql_client, :default_headers) ||
         [])
  end

  defp required_url(opts, key) do
    Map.get(opts, key) || Application.get_env(:simple_graphql_client, key) ||
      raise "Please specify #{key} either in config file or pass it in opts"
  end
end
