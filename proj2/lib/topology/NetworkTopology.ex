defmodule Proj2.Topology.NetworkTopology do

  @callback get_neighbors(nodes :: integer()) :: [[integer()]]

  def get_neighbors(nodes, topology) do
    case topology do
      "full" -> Proj2.Topology.CompleteTopology.get_neighbors(nodes)
      "line" -> Proj2.Topology.LinearTopology.get_neighbors(nodes)
      "rand2D" -> Proj2.Topology.RandPlanarTopology.get_neighbors(nodes)
      "3Dtorus" -> Proj2.Topology.CubicTopology.get_neighbors(nodes)
      "honeycomb" -> Proj2.Topology.HexagonalTopology.get_neighbors(nodes)
      "randhoneycomb" -> Proj2.Topology.RandHexagonalTopology.get_neighbors(nodes)
    end
  end

end
