defmodule HexagonalTopology do
  @behaviour NetworkTopology

  @impl NetworkTopology
  def get_neighbors(nodes) do
    points = Enum.map(0..nodes - 1, fn id ->
      if id == 0 do {id, 0, 0} else
        ring = ceil((:math.sqrt(12 * id + 9) - 3) / 6)
        norm = id - 3 * ring * (ring - 1) - 1
        rem = rem(norm, ring)
        case div(norm, ring) do
          0 -> {id, ring - rem, rem}
          1 -> {id, -rem, ring}
          2 -> {id, -ring, ring - rem}
          3 -> {id, rem - ring, -rem}
          4 -> {id, rem, -ring}
          5 -> {id, ring, rem - ring}
        end
      end
    end)
    Enum.map(points, fn {id1, x1, y1} ->
      Enum.filter(points, fn {id2, x2, y2} ->
        id1 != id2 and Enum.max([abs(x1 - x2), abs(y1 - y2), abs(x1 + y1 - x2 - y2)]) == 1
      end)
      |> Enum.map(fn {id, _, _} -> id end)
    end)
  end

end
