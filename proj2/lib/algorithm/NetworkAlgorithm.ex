defmodule NetworkAlgorithm do

  @callback init(id) :: state when id: integer(), state: tuple()

  def init(id, neighbors, algorithm) do
    state = case algorithm do
      "gossip" -> GossipAlgorithm.init(id)
      "push-sum" -> PushSumAlgorithm.init(id)
    end
    {state, neighbors, algorithm}
  end

  @callback process(message, state) :: {:continue, message, state} | {:terminate, state} when message: any(), state: tuple()

  def process(message, {state, neighbors, algorithm}) do
    state = case algorithm do
      "gossip" -> GossipAlgorithm.process(message, state)
      "push-sum" -> PushSumAlgorithm.process(message, state)
    end
    case state do
      {:continue, message, state} -> {:continue, message, {state, neighbors, algorithm}}
      {:terminate, state} -> {:terminate, {state, neighbors, algorithm}}
    end
  end

end
