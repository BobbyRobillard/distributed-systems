defmodule GossipAlgorithm do
  @behaviour NetworkAlgorithm

  @impl NetworkAlgorithm
  def init_state(_), do: 0

  @impl NetworkAlgorithm
  def init_message(message), do: message

  @impl NetworkAlgorithm
  def process(message, count) do
    case count + 1 do
      10 -> {:terminate, 10}
      c -> {:continue, message, c}
    end
  end

end
