defmodule GossipAlgorithm do
  @behaviour NetworkAlgorithm

  @impl NetworkAlgorithm
  def init(_) do
    {0}
  end

  @impl NetworkAlgorithm
  def process(message, {count}) do
    c = count + 1
    cond do
      c < 10 -> {:continue, message, {c}}
      true -> {:terminate, {c}}
    end
  end

end
