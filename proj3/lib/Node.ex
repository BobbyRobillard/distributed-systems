defmodule Proj3.Node do
  use GenServer

  def join_network() do
    IO.puts "Joining"
  end

  def leave_network do
    IO.puts "Leaving"
  end

  def route_to_node do
    IO.puts "Sending to node"
  end

  # def start_link(id, neighbors, algorithm) do
  #   state = {neighbors, algorithm, algorithm.init_state(id), false}
  #   GenServer.start_link(Proj3.Node, state, name: Proj3.Network.name(id))
  # end
  #
  # def send(id, message), do: GenServer.cast(Proj3.Network.name(id), {:process, message})
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
