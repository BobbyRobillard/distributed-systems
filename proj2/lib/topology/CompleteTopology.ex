defmodule Proj2.CompleteTopology do
  @behaviour Proj2.NetworkTopology

  @impl Proj2.NetworkTopology
  def get_neighbors(nodes) do
    Enum.map(0..nodes - 1, fn id1 ->
      Enum.filter(0..nodes - 1, fn id2 -> id1 != id2 end)
    end)
  end

end
