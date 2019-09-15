defmodule Proj2.Topology.CompleteTopology do
  @behaviour Proj2.Topology.NetworkTopology

  @impl Proj2.Topology.NetworkTopology
  def get_neighbors(nodes) do
    Enum.map(1..nodes, fn id1 ->
      Enum.filter(1..nodes, fn id2 -> id1 != id2 end)
    end)
  end

end
