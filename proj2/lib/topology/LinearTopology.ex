defmodule LinearTopology do
  @behaviour NetworkTopology

  @impl NetworkTopology
  def get_neighbors(nodes) do
    Enum.map(0..nodes - 1, fn id ->
      Enum.filter([id - 1, id + 1], fn id ->
        id >= 0 and id < nodes
      end)
    end)
  end

end
