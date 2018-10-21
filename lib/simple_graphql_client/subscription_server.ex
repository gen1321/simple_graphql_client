defmodule SimpleGraphqlClient.SubscriptionServer do
  use GenServer
  require Logger
  alias SimpleGraphqlClient.WebSocket

  def start_link do
    state = %{
      socket: WebSocket,
      subscriptions: %{},
    }
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  def init(state) do
    {:ok, state}
  end

  def subscribe(subscription_name, callback_or_dest, query, variables \\ []) do
    GenServer.cast(__MODULE__, {:subscribe, subscription_name, callback_or_dest, query, variables})
  end

  def handle_cast({:subscribe, subscription_name, callback_or_dest, query, variables}, %{socket: socket, subscriptions: subscriptions} = state) do
    WebSocket.subscribe(socket, self(), subscription_name, query, variables)

    callbacks = Map.get(subscriptions, subscription_name, [])
    subscriptions = Map.put(subscriptions, subscription_name, [callback_or_dest | callbacks])
    state = Map.put(state, :subscriptions, subscriptions)

    {:noreply, state}
  end

  # Incoming Notifications (from SimpleGraphqlClient.WebSocket)
  def handle_cast({:subscription, subscription_name, response}, %{subscriptions: subscriptions} = state) do
    Map.get(subscriptions, subscription_name, [])
    |> Enum.each(fn(callback_or_dest) -> handle_callback_or_dest(callback_or_dest, response) end)
    {:noreply, state}
  end

  def handle_cast({:joined},  state) do
    {:noreply, state}
  end

  defp handle_callback_or_dest(callback_or_dest, response) do
    if is_function(callback_or_dest) do
      callback_or_dest.(response)
    else
      send(callback_or_dest, response)
    end
  end
end
