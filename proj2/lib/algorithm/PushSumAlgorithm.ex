defmodule PushSumAlgorithm do
  @behaviour NetworkAlgorithm

  @impl NetworkAlgorithm
  def init(id) do
    {id, 1, id, 0}
  end

  @impl NetworkAlgorithm
  def process({sm, wm}, {s, w, ratio, count}) do
    s = s + sm
    w = w + wm
    r = s / w
    c = if abs(ratio - r) <= 1.0e-10 do count + 1 else 0 end
    cond do
      c < 3 -> {:continue, {s / 2, w / 2}, {s / 2, w / 2, r, c}}
      true -> {:terminate, {s, w, r, c}}
    end
  end

end
