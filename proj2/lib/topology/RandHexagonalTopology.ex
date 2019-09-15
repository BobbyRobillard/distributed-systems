defmodule RandHexagonalTopology do
  @behaviour NetworkTopology

  @impl NetworkTopology
  def get_neighbors(nodes) do
    Enum.map(HexagonalTopology.get_neighbors(nodes), fn neighbors ->
      id = :rand.uniform(nodes)
      if Enum.member?(neighbors, id) do neighbors else Enum.sort([id | neighbors]) end
    end)
  end

end
