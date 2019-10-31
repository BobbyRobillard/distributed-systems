defmodule Proj3.Node do
  use GenServer

  def receive_message(node_id, message)do
    IO.puts "Message received"
  end

  def pass_message(node_id, receiver_id, message) do
    IO.puts "Sending message to node"
  end

  def start_link(node_id, hash_table) do
    state = {hash_table}
    GenServer.start_link(Proj3.Node, state, name: Proj3.Network.name(node_id))
  end

  def send(node_id, receiver_id, message), do: GenServer.cast(Proj3.Node.name(node_id), {:pass_message, message})
  #
  # @impl GenServer
  # def init(state), do: {:ok, state}
  #
  # @impl GenServer
  # def handle_cast({:process, message}, {neighbors, algorithm, state, visited}) do
  #     if !visited do
  #       Agent.update(:global, fn {nodes, visited, start} -> {nodes, visited + 1, start} end)
  #     end
  #     state = case algorithm.process(message, state) do
  #       {:continue, message, state} ->
  #         Proj3.Node.send(Enum.random(neighbors), message)
  #         state
  #       {:terminate, state} ->
  #         Task.async(&Proj3.Network.terminate/0)
  #         state
  #     end
  #     {:noreply, {neighbors, algorithm, state, true}}
  # end

end
