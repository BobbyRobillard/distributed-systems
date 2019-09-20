defmodule NetworkTopology do

  def of("full"), do: CompleteTopology
  def of("line"), do: LinearTopology
  def of("rand2D"), do: RandPlanarTopology
  def of("3Dtorus"), do: CubicTopology
  def of("honeycomb"), do: HexagonalTopology
  def of("randhoneycomb"), do: RandHexagonalTopology

  @callback get_neighbors(nodes :: integer()) :: [[integer()]]

end
