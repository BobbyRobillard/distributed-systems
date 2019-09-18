defmodule GossipAlgorithm do
  @behaviour NetworkAlgorithm

  @impl NetworkAlgorithm
  def process(message, {count, neighbors}) do
    c = count + 1
    cond do
      c < 10 -> {:continue, message, {c, neighbors}}
      true -> {:terminate, {c, neighbors}}
    end
  end

end
