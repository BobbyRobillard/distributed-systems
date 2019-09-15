defmodule Proj2.Topology.LinearTopology do
  @behaviour Proj2.Topology.NetworkTopology

  @impl Proj2.Topology.NetworkTopology
  def get_neighbors(nodes) do
    Enum.map(1..nodes, fn id ->
      Enum.filter([id - 1, id + 1], fn id ->
        id >= 1 and id <= nodes
      end)
    end)
  end

end
