defmodule Proj2.Node do
  use GenServer

  def start_link(id, neighbors, algorithm) do
    state = {neighbors, algorithm, algorithm.init_state(id), false}
    GenServer.start_link(Proj2.Node, state, name: Proj2.Network.name(id))
  end

  def send(id, message), do: GenServer.cast(Proj2.Network.name(id), {:process, message})

  @impl GenServer
  def init(state), do: {:ok, state}

  @impl GenServer
  def handle_cast({:process, message}, {neighbors, algorithm, state, visited}) do
      if !visited do
        Agent.update(:global, fn {nodes, visited, start} -> {nodes, visited + 1, start} end)
      end
      state = case algorithm.process(message, state) do
        {:continue, message, state} ->
          Proj2.Node.send(Enum.random(neighbors), message)
          state
        {:terminate, state} ->
          Task.async(&Proj2.Network.terminate/0)
          state
      end
      {:noreply, {neighbors, algorithm, state, true}}
  end

end
