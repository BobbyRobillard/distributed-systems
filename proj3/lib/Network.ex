defmodule Proj3.Network do
  use Supervisor
  use Bitwise

  def name(id), do: {:via, Registry, {:registry, id}}

  def gen_id(), do: :rand.uniform(0x10000) - 1

  def digit_at(id, level), do: (id >>> (16 - 4 * level)) &&& 0xF

  def start_link(num_nodes) do
    IO.puts "Network started..."

    # Intialize global hash table
    Agent.start_link(fn -> %{} end, name: :global)

    # Initialize the DHT of the root node
    add_node(get_id())

    # Spawn off any additonal nodes as needed
    nodes = 1..num_nodes
    |> Enum.each(fn  ->
        # Each nodes needs to be initialized with the proper hash map
        id = get_id()
        worker(Proj3.Node, [id, get_neighbors(id)], [id: id])
      end)

    # Initialize our registry. This will know of all nodes in the network.
    Supervisor.start_link(Proj3.Network, [supervisor(Registry, [:unique, :registry]) | [root] | nodes], name: :network)

    run()
  end

  def create_node() do
    id = gen_id();
    #TODO: Start worker
    Proj3.Node.insert(-1, gen_id, 1)
    id
  end

  def add_node(node_id) do
    # Access global list
    routing_map = Agent.get(:global, & &1)

    # See if anything needs to be replaced in global hash table
      # Get the first digit of the node_id, find that corresponding entry in the GHT
      # If new node's id less than value in GHT, update value
    # Use global hash table to generate hash table for new node
    # Add new node to network
    # Have new node multicast to entries in its hash table about its existence
    # Print new node's id to user
  end

  def remove_node(node_id) do
    # Access global list
    routing_map = Agent.get(:global, & &1)
    # Multicast to immediate neighbors about node's removal
    # Remove node from global hash table if needed
  end

  @impl Supervisor
  def init(children), do: supervise(children, strategy: :one_for_one)

end
