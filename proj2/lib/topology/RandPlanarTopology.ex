defmodule Proj2.Topology.RandPlanarTopology do
  @behaviour Proj2.Topology.NetworkTopology

  @impl Proj2.Topology.NetworkTopology
  def get_neighbors(nodes) do
    points = Enum.map(1..nodes, fn id ->
      {id, :random.uniform() * 2 - 1, :random.uniform() * 2 - 1}
    end)
    Enum.map(points, fn {id1, x1, y1} ->
      Enum.filter(points, fn {id2, x2, y2} ->
        id1 != id2 and :math.sqrt(:math.pow(x1 - x2, 2) + :math.pow(y1 - y2, 2)) <= 0.1
      end) |> Enum.map(fn {id, _, _} -> id end)
    end)
  end

end
