defmodule NetworkAlgorithm do

  @callback process(message, state) :: {:continue, message, state} | {:terminate, state} when message: any(), state: tuple()

  def process(message, state, algorithm) do
    case algorithm do
      "gossip" -> GossipAlgorithm.process(message, state)
      "push-sum" -> PushSumAlgorithm.process(message, state)
    end
  end

end
