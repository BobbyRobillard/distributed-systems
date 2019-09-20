defmodule Proj2.Node do
  use GenServer

  #############################################################################
  #                                   API                                     #
  #############################################################################


  def start_link(name) do
    GenServer.start_link(__MODULE__, [], name: via_tuple(name))
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


  def init(_state) do
    # Initialize our s & w
    {:ok, %{}}
  end


  def handle_cast({:update_state, new_state}, state) do
      # Algorithm.NetworkAlgorithm(new_state)
      {:noreply, state}
  end


   # Return actor's state
   def handle_call(:get_state, _from, state) do
      {:reply, state, state}
   end


  #############################################################################
  #                              Helper Functions                             #
  #############################################################################


end
