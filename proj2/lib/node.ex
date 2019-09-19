defmodule Proj2.Node do
  use GenServer

  #############################################################################
  #                                   API                                     #
  #############################################################################


  def start_link(name) do
    GenServer.start_link(__MODULE__, [], name: via_tuple(name))
  end


  def demo(node_number, message) do
    GenServer.cast(via_tuple(node_number), {:demo, message})
  end


  def get_state(node_number) do
    GenServer.call(via_tuple(node_number), :get_state)
  end


  defp via_tuple(node_number) do
    {:via, Proj2.Registry, {:node, node_number}}
  end


  #############################################################################
  #                                   SERVER                                     #
  #############################################################################


  def init(_state) do
    # Initialize our s & w
    {:ok, %{}}
  end


  def handle_cast({:demo, message}, state) do
      IO.puts message
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
