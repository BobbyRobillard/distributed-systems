defmodule Proj2.Node do
  use GenServer

  #############################################################################
  #                                   API                                     #
  #############################################################################


  def start_link(name) do
    GenServer.start_link(__MODULE__, [], name: via_tuple(name))
  end


  def gossip_update(node_name) do
    GenServer.cast(via_tuple(node_name), {:gossip_update, node_name})
  end


  def push_sum_update(node_name, message) do
    GenServer.cast(via_tuple(node_name), {:push_sum_update, message})
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


  def handle_cast({:gossip_update, node_name}, state) do
    if ! Map.get(state, :terminated) do

      new_count = Map.get(state, :count) + 1

      case new_count do
        10 -> {:noreply, Map.put(state, :terminated, true)} # Terminate

        _ -> (get_random_neighbor(node_name) |> Proj2.Node.gossip_update # Gossip to random neighbor
             {:noreply, Map.put(state, :count, new_count)}) # Increment our count
      end

    else
      {:noreply, new_state}) # Already terminated, do nothing.
    end

  end


  def handle_cast({:push_sum_update, message}, state) do
    if ! Map.get(state, :terminated) do # Check for terminated node
      # 1) Add sum to our sum
      # 2) Check if time to terminate
      #    - a) If it is then terminated
      #    - b) Otherwise send message to random neighbor

      # {
      #     :noreply,
      #     %{
      #       # our "s" + other messages's "s"
      #       s: (Map.get(state, :s) + Map.get(message, :s)),
      #       # our "w" + other messages's "w"
      #       w: (Map.get(state, :w) + Map.get(message, :w)),
      #     }
      # }

    else
      {:noreply, new_state}) # Already terminated, do nothing.
    end

   end


   # Return actor's state
   def handle_call(:get_state, _from, state) do
     {:reply, state, state}
   end


  #############################################################################
  #                              Helper Functions                             #
  #############################################################################

  def get_random_neighbor do
    "node2"
  end

  def get_neighbors do
    [1,2,3]
  end

  
end
