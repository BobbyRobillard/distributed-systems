defmodule Proj1.Registry do
  use GenServer

  ##############################################################################
  #                                  API                                       #
  ##############################################################################


  def start_link do
    GenServer.start_link(__MODULE__, nil, name: :registry)
  end


  def whereis_name(worker_name) do
    GenServer.call(:registry, {:whereis_name, worker_name})
  end


  def register_name(worker_name, pid) do
    GenServer.call(:registry, {:register_name, worker_name, pid})
  end


  def unregister_name(worker_name) do
    GenServer.cast(:registry, {:unregister_name, worker_name})
  end


  def send(worker_name, range) do
    # If we try to send a message to a process
    # that is not registered, we return a tuple in the format
    # {:bad_name, {process_name, error_message}}.
    # Otherwise, we just forward the range to to solve to the pid of this
    # worker.
    case whereis_name(worker_name) do
      :undefined ->
        {:bad_name, {worker_name, range}}

      pid ->
        Kernel.send(pid, range)
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


  def handle_call({:whereis_name, worker_name}, _from, state) do
    {:reply, Map.get(state, worker_name, :undefined), state}
  end


  def handle_call({:register_name, worker_name, pid}, _from, state) do
    # Registering a name is just a matter of putting it in our Map.
    # Our response tuple include a `:no` or `:yes` indicating if
    # the process was included or if it was already present.
    case Map.get(state, worker_name) do
      nil ->
        {:reply, :yes, Map.put(state, worker_name, pid)}
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


  def handle_cast({:unregister_name, worker_name}, state) do
    {:noreply, Map.delete(state, worker_name)}
  end


  ##############################################################################
end
