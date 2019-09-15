defmodule CubicTopology do
  @behaviour NetworkTopology

  @impl NetworkTopology
  def get_neighbors(nodes) do
    side = ceil(:math.pow(nodes, 1/3))
    points = Enum.map(1..nodes, fn id ->
      {id, rem(id - 1, side) + 1, rem(div(id - 1, side), side) + 1, rem(div(id - 1, side * side), side) + 1}
    end)
    Enum.map(points, fn {id1, x1, y1, z1} ->
      Enum.filter(points, fn {id2, x2, y2, z2} ->
        case {id1, id2, x1, x2, y1, y2, z1, z2} do
          {i, i, _, _, _, _, _, _} -> false
          {_, _, _, _, y, y, z, z} -> abs(x1 - x2) == 1 or rem(x1 + x2, side) == 1
          {_, _, x, x, _, _, z, z} -> abs(y1 - y2) == 1 or rem(y1 + y2, side) == 1
          {_, _, x, x, y, y, _, _} -> abs(z1 - z2) == 1 or rem(z1 + z2, side) == 1
          _ -> false
        end
      end)
      |> Enum.map(fn {id, _, _, _} -> id end)
    end)
  end

end
