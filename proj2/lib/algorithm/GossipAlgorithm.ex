defmodule Proj2.GossipAlgorithm do
  @behaviour Proj2.NetworkAlgorithm

  @impl Proj2.NetworkAlgorithm
  def init_state(_), do: 0

  @impl Proj2.NetworkAlgorithm
  def init_message(message), do: message

  @impl Proj2.NetworkAlgorithm
  def process(message, count) do
    case count + 1 do
      10 -> {:terminate, 10}
      c -> {:continue, message, c}
    end
  end

end
