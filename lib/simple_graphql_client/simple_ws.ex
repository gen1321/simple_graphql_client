defmodule SimpleGraphqlClient.WebSocket do
  use WebSockex

  def start_link do
    ws_url = "ws://localhost:4000/socket/websocket"
    WebSockex.start_link(ws_url, __MODULE__, %{})
  end

  def handle_frame({type, msg}, state) do
    IO.puts "Received Message - Type: #{inspect type} -- Message: #{inspect msg}"
    {:ok, state}
  end

  def handle_cast({:send, {type, msg} = frame}, state) do
    IO.puts "Sending #{type} frame with payload: #{msg}"
    {:reply, frame, state}
  end
end
