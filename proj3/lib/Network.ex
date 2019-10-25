defmodule Proj3.Network do
  use Supervisor

  def init(children), do: supervise(children, strategy: :one_for_one)

  def start_link(num_nodes) do
    IO.puts "Network started..."

    # Initialize the DHT of the root node
    root = worker(Proj3.Node, [id, %{})

    # Spawn off any additonal nodes as needed
    nodes = 1..num_nodes
    |> Enum.each(fn  ->
        # Each nodes needs to be initialized with the proper hash map
        worker(Proj3.Node, [id, get_neighbors(id)], [id: id])
      end)

    # Initialize our registry. This will know of all nodes in the network.
    Supervisor.start_link(Proj3.Network, [supervisor(Registry, [:unique, :registry]) | [root] | nodes], name: :network)

    run()
  end
end
