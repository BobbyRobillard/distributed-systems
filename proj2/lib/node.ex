defmodule Proj2.Node do
  use GenServer

  #############################################################################
  #                                   API                                     #
  #############################################################################


  def start_link(name) do
    GenServer.start_link(__MODULE__, [], name: via_tuple(name))
  end


  def update_state(node_name, message) do
    GenServer.cast(via_tuple(node_name), {:update_state, message})
  end

  def send_message(node_name, receiver_node_name) do
    GenServer.cast(via_tuple(node_name), {:send_message, receiver_node_name})
  end


  def get_state(node_name) do
    GenServer.call(via_tuple(node_name), :get_state)
  end


  defp via_tuple(node_name) do
    {:via, Proj2.Registry, {:node, node_name}}
  end


  #############################################################################
  #                                   SERVER                                     #
  #############################################################################


  def init(_state) do
    # Initialize our s & w
    {:ok, Map.new( [{:s, 0}, {:w, 0}] )}
  end


  # Update an actor's state
  def handle_cast({:send_message, receiver_node_name}, state) do
      half_s = trunc(Map.get(state, :s)/2)
      half_w = trunc(Map.get(state, :w)/2)

      # Update state of other node
      Proj2.Node.update_state(
        receiver_node_name,
        %{
          s: half_s,
          w: half_w,
        }
      )

      {
          :noreply,
          state # Update our own state
          |> Map.replace!(:s, half_s)
          |> Map.replace!(:w, half_w)
      }
   end

  # Update an actor's state
  def handle_cast({:update_state, message}, state) do
      {
          :noreply,
          %{
            # our "s" + other actor's "s"
            s: (Map.get(state, :s) + Map.get(message, :s)),
            # our "w" + other actor's "w"
            w: (Map.get(state, :w) + Map.get(message, :w)),
          }
      }
   end


   # Return actor's state
   def handle_call(:get_state, _from, state) do
     {:reply, state, state}
   end


  #############################################################################
  #                              Helper Functions                             #
  #############################################################################

end
