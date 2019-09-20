defmodule PushSumAlgorithm do
  @behaviour NetworkAlgorithm

  @impl NetworkAlgorithm
  def init_state(id), do: {id, 1, id, 0}

  @impl NetworkAlgorithm
  def init_message(message), do: {message, 0, 0}

  @impl NetworkAlgorithm
  def process({message, sm, wm}, {s, w, ratio, count}) do
    s = s + sm
    w = w + wm
    r = s / w
    case (if abs(ratio - r) <= 1.0e-10 do count + 1 else 0 end) do
      3 -> {:terminate, {s, w, r, 3}}
      c -> {:continue, {message, s / 2, w / 2}, {s / 2, w / 2, r, c}}
    end
  end

end
