defmodule Proj2.RandHexagonalTopology do
  @behaviour Proj2.NetworkTopology

  @impl Proj2.NetworkTopology
  def get_neighbors(nodes) do
    Enum.map(Proj2.HexagonalTopology.get_neighbors(nodes), fn neighbors ->
      id = :rand.uniform(nodes) - 1
      if Enum.member?(neighbors, id) do neighbors else Enum.sort([id | neighbors]) end
    end)
  end

end
