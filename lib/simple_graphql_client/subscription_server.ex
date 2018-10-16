#original source code at https://github.com/annkissam/absinthe_websocket/blob/master/lib/absinthe_websocket/subscription_server.ex
# Credentials goes to github.com/annkissam

defmodule SimpleGraphqlClient.SubscriptionServer do
  use GenServer
  require Logger

  def start_link(args, opts) do
    socket = Keyword.get(args, :socket)
    # subscriber = Keyword.get(args, :subscriber)
    state = %{
      socket: socket,
      subscriptions: %{},
    }

    IO.inspect("aset")
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  def init(state) do
    {:ok, state}
  end

  def subscribe(subscription_name, callback, query, variables \\ []) do
    IO.inspect("alive1")
    GenServer.cast(__MODULE__, {:subscribe, subscription_name, callback, query, variables})
  end

  def handle_cast({:subscribe, subscription_name, callback, query, variables}, %{socket: socket, subscriptions: subscriptions} = state) do
    SimpleGraphqlClient.WebSocket.subscribe(socket, self(), subscription_name, query, variables)
    callbacks = Map.get(subscriptions, subscription_name, [])
    subscriptions = Map.put(subscriptions, subscription_name, [callback | callbacks])
    state = Map.put(state, :subscriptions, subscriptions)
    {:noreply, state}
  end

  # Incoming Notifications (from SimpleGraphqlClient.WebSocket)
  def handle_cast({:subscription, subscription_name, response}, %{subscriptions: subscriptions} = state) do
    # handle_subscription(subscription_name, response)

    Map.get(subscriptions, subscription_name, [])
    |> Enum.each(fn(callback) -> callback.(response) end)

    {:noreply, state}
  end

  def handle_cast({:joined}, state) do
    # apply(subscriber, :subscribe, [])
    IO.inspect("joined")
    {:noreply, state}
  end
end
