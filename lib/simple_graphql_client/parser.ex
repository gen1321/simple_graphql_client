defmodule SimpleGraphqlClient.Parser do
  alias SimpleGraphqlClient.Response

  def parse_response({:ok, %{status_code: 200} = resp}) do
    {:ok,
     %Response{
       body: Poison.decode(resp.body),
       status_code: resp.status_code,
       headers: resp.headers
     }}
  end

  def parse_response({:ok, resp}) do
    case Poison.decode(resp.body) do
      {:ok, body} ->
        {:error, %Response{body: body, status_code: resp.status_code, headers: resp.headers}}

      {:error, _} ->
        {:error, %Response{body: resp.body, status_code: resp.status_code, headers: resp.headers}}
    end
  end

  def parse_response({:error, resp}) do
    {:error, resp}
  end
end
