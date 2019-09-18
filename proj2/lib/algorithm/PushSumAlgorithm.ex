defmodule PushSumAlgorithm do
  @behaviour NetworkAlgorithm

  @impl NetworkAlgorithm
  def process({sm, wm}, {s, w, ratio, count, neighbors}) do
    s = s + sm
    w = w + wm
    r = s / w
    c = if abs(ratio - r) <= 1.0e-10 do count + 1 else 0 end
    cond do
      c < 3 -> {:continue, {s / 2, w / 2}, {s / 2, w / 2, r, c, neighbors}}
      true -> {:terminate, {s, w, r, c, neighbors}}
    end
  end

end
