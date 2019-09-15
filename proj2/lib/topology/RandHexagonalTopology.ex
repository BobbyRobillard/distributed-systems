defmodule Proj2.Topology.RandHexagonalTopology do
  @behaviour Proj2.Topology.NetworkTopology

  @impl Proj2.Topology.NetworkTopology
  def get_neighbors(nodes) do
    Enum.map(Proj2.Topology.HexagonalTopology.get_neighbors(nodes), fn neighbors ->
      id = :rand.uniform(nodes)
      if Enum.member?(neighbors, id) do neighbors else Enum.sort([id | neighbors]) end
    end)
  end

end
