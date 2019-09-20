defmodule Node do
  use GenServer

  #############################################################################
  #                                   API                                     #
  #############################################################################


  def start_link(node_id, neighbors, algorithm) do
    GenServer.start_link(
      __MODULE__,
      NetworkAlgorithm.init(node_id, neighbors, algorithm),
      name: via_tuple(node_id))
  end


  def update_state(node, state) do
    GenServer.cast(via_tuple(node), {:update_state, state})
  end


  def get_state(node) do
    GenServer.call(via_tuple(node), :get_state)
  end


  defp via_tuple(node) do
    {:via, Proj2.Registry, {:node, node}}
  end


  #############################################################################
  #                                   SERVER                                     #
  #############################################################################


  def init(state) do
    {:ok, state}
  end


  def handle_cast({:update_state, new_state}, _state) do
      {:noreply, new_state}
  end


   # Return actor's state
   def handle_call(:get_state, _from, state) do
      {:reply, state, state}
   end


  #############################################################################
  #                              Helper Functions                             #
  #############################################################################


end
