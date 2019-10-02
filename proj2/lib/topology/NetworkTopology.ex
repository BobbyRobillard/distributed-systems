defmodule Proj2.NetworkTopology do

  def of("full"), do: Proj2.CompleteTopology
  def of("line"), do: Proj2.LinearTopology
  def of("rand2D"), do: Proj2.RandPlanarTopology
  def of("3Dtorus"), do: Proj2.CubicTopology
  def of("honeycomb"), do: Proj2.HexagonalTopology
  def of("randhoneycomb"), do: Proj2.RandHexagonalTopology

  @callback get_neighbors(nodes :: integer()) :: [[integer()]]

end
