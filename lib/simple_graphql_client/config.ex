defmodule SimpleGraphqlClient.Config do
  @default_headers [{"Content-Type", "application/json"}]
  def api_url(opts) do
    required_url(opts, :url)
  end

  def ws_api_url(opts) do
    required_url(opts, :ws_url)
  end

  def headers(opts) do
    @default_headers ++ (Keyword.get(opts, :headers) || [])
  end

  defp required_url(opts, key) do
    Keyword.get(opts, key) || raise "Please pass #{key} it in opts"
  end
end
