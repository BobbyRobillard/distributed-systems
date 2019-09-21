defmodule Node do
  use GenServer

  def start_link(id, neighbors, algorithm) do
    state = {neighbors, algorithm, algorithm.init_state(id), false}
    GenServer.start_link(Node, state, name: Network.name(id))
  end

  def send(id, message), do: GenServer.cast(Network.name(id), {:process, message})

  @impl GenServer
  def init(state), do: {:ok, state}

  @impl GenServer
  def handle_cast({:process, message}, {neighbors, algorithm, state, visited}) do
      if !visited do
        Agent.update(:global, fn {nodes, visited, start} -> {nodes, visited + 1, start} end)
      end
      state = case algorithm.process(message, state) do
        {:continue, message, state} ->
          Node.send(Enum.random(neighbors), message)
          state
        {:terminate, state} ->
          Task.async(&Network.terminate/0)
          state
      end
      {:noreply, {neighbors, algorithm, state, true}}
  end

end
