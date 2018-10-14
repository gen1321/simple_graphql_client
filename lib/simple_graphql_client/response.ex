defmodule SimpleGraphqlClient.Response do
  @type t :: %SimpleGraphqlClient.Response{body: map, status_code: integer, headers: keyword()}

  defstruct body: %{},
            status_code: nil,
            headers: nil
end
