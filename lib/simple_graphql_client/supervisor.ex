defmodule SimpleGraphqlClient.Supervisor do
  use Supervisor
  alias SimpleGraphqlClient.SubscriptionServer
  alias SimpleGraphqlClient.WebSocket

  def start_link(args \\ %{}) do
    Supervisor.start_link(__MODULE__, args, name: :simple_graphql_client_supervisor)
  end

  # name: OrgmanicQLApi.Websocket.Supervisor
  # name: OrgmanicQLApi.Websocket.QueryServer
  # name: OrgmanicQLApi.Websocket.SubscriptionServer

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

    # restart everything on failures
    # It'd be nice if the QueryServer & SubscriptionServer could recover...
    Supervisor.init(children, strategy: :one_for_all)
  end
end
