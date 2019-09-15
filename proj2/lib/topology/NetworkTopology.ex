defmodule NetworkTopology do

  @callback get_neighbors(nodes :: integer()) :: [[integer()]]

  def get_neighbors(nodes, topology) do
    case topology do
      "full" -> CompleteTopology.get_neighbors(nodes)
      "line" -> LinearTopology.get_neighbors(nodes)
      "rand2D" -> RandPlanarTopology.get_neighbors(nodes)
      "3Dtorus" -> CubicTopology.get_neighbors(nodes)
      "honeycomb" -> HexagonalTopology.get_neighbors(nodes)
      "randhoneycomb" -> RandHexagonalTopology.get_neighbors(nodes)
    end
  end

end
