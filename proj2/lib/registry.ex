defmodule Proj2.Registry do
  use GenServer

  ##############################################################################
  #                                  API                                       #
  ##############################################################################


  def start_link do
    GenServer.start_link(__MODULE__, nil, name: :registry)
  end


  def whereis_name(node_number) do
    GenServer.call(:registry, {:whereis_name, node_number})
  end


  def register_name(node_number, pid) do
    GenServer.call(:registry, {:register_name, node_number, pid})
  end


  def unregister_name(node_number) do
    GenServer.cast(:registry, {:unregister_name, node_number})
  end


  def send(node_number, message) do
    case whereis_name(node_number) do
      :undefined ->
        {:bad_name, {node_number, message}}

      pid ->
        Kernel.send(pid, message)
        pid
    end
  end


  ##############################################################################
  #                               SERVER                                       #
  ##############################################################################


  def init(_) do
    # We will use a simple Map to store our processes in
    # the format %{"room name" => pid}
    {:ok, Map.new}
  end


  def handle_call({:whereis_name, node_number}, _from, state) do
    {:reply, Map.get(state, node_number, :undefined), state}
  end


  def handle_call({:register_name, node_number, pid}, _from, state) do
    # Registering a name is just a matter of putting it in our Map.
    # Our response tuple include a `:no` or `:yes` indicating if
    # the process was included or if it was already present.
    case Map.get(state, node_number) do
      nil ->
        {:reply, :yes, Map.put(state, node_number, pid)}
      _ ->
        {:reply, :no, state}
    end
  end


  def handle_info({:DOWN, _, :process, pid, _}, state) do
  # When a monitored process dies, we will receive a
  # `:DOWN` message that we can use to remove the
  # dead pid from our registry.
  {:noreply, remove_pid(state, pid)}
  end


  def remove_pid(state, pid_to_remove) do
    # And here we just filter out the dead pid
    remove = fn {_key, pid} -> pid  != pid_to_remove end
    Enum.filter(state, remove) |> Enum.into(%{})
  end


  def handle_cast({:unregister_name, node_number}, state) do
    {:noreply, Map.delete(state, node_number)}
  end


  ##############################################################################
end
