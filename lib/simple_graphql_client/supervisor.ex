defmodule SimpleGraphqlClient.Supervisor do
  @moduledoc """
    Supervisor for WS related genservers
  """
  use Supervisor
  alias SimpleGraphqlClient.SubscriptionServer
  alias SimpleGraphqlClient.WebSocket

  def start_link(args \\ %{}) do
    Supervisor.start_link(__MODULE__, args, name: :simple_graphql_client_supervisor)
  end

  def init(args) do
    subscription_server_name = SubscriptionServer
    socket_name = WebSocket
    ws_url = Keyword.get(args, :ws_url)

    children = [
      worker(SubscriptionServer, []),
      worker(WebSocket, [
        [ws_url: ws_url]
      ])
    ]

    Supervisor.init(children, strategy: :one_for_all)
  end
end
