defmodule Proj2.Supervisor do
  use Supervisor


  def start_link do
    Supervisor.start_link(__MODULE__, [], name: :node_supervisor)
  end


  def start_node(node_id, neighbors, algorithm) do
    Supervisor.start_child(:node_supervisor, [node_id, neighbors]) # Start new node
    Node.update_state(# Setup initial state of node that was just created
      node_id,
      NetworkAlgorithm.init(node_id, neighbors, algorithm)
    )
  end


  def setup_nodes(nodes, topology, algorithm) do
    neighbors = NetworkTopology.get_neighbors(nodes, topology)
    Enum.reduce(1..nodes, [], fn node_id, acc ->
        acc ++ [
          Proj2.Supervisor.start_node(
            node_id,
            Enum.at(neighbors, node_id - 1), # Set neighbors of each node
            algorithm
          )
        ]
    end)
  end


  def init(_) do
    children = [
      worker(Proj2.Node, [])
    ]

    supervise(children, strategy: :simple_one_for_one)
  end


end
