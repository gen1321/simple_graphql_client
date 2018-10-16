defmodule SimpleGraphqlClient.Supervisor do
  use Supervisor

  def start_link(args) do
    Supervisor.start_link(__MODULE__, args, name: :simple_graphql_client_supervisor)
  end

  # name: OrgmanicQLApi.Websocket.Supervisor
  # name: OrgmanicQLApi.Websocket.QueryServer
  # name: OrgmanicQLApi.Websocket.SubscriptionServer

  def init(args) do
    base_name = __MODULE__
    subscription_server_name = Module.concat(base_name, SubscriptionServer)
    socket_name = Module.concat(base_name, Socket)
    url = Keyword.get(args, :url)
    token = Keyword.get(args, :token)

    children = [
      worker(SimpleGraphqlClient.SubscriptionServer, [[socket: socket_name], [name: subscription_server_name]]),
      worker(SimpleGraphqlClient.WebSocket, [[subscription_server: subscription_server_name, url: url, token: token], [name: socket_name]]),
    ]

    # restart everything on failures
    # It'd be nice if the QueryServer & SubscriptionServer could recover...
    Supervisor.init(children, strategy: :one_for_all)
  end
end
