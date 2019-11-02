defmodule Proj3.Network do
  use DynamicSupervisor
  use Bitwise

  def name(id), do: {:via, Registry, {:registry, id}}

  def gen_id(), do: :rand.uniform(0x10000) - 1

  def digit_at(id, level), do: (id >>> (16 - 4 * level)) &&& 0xF

  def start_link(num_nodes) do
    IO.puts "Network started..."

    DynamicSupervisor.start_link(__MODULE__, :ok, name: __MODULE__)

    # dynamic_supervisor(Registry,[:unique, :registry])

    # # Initialize root node
    # start_child()
    #
    # # Spawn off any additonal nodes as needed
    # Enum.each(1..num_nodes, fn x -> start_child() end)
  end

  @impl true
  def init(_init_arg), do: DynamicSupervisor.init(strategy: :one_for_one)

  def start_child() do
    # If MyWorker is not using the new child specs, we need to pass a map:
    # spec = %{id: MyWorker, start: {MyWorker, :start_link, [foo, bar, baz]}}
    spec = {Proj3.Node, name: gen_id()}
    DynamicSupervisor.start_child(__MODULE__, spec)
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

end
