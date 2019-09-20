defmodule NetworkAlgorithm do

  def of("gossip"), do: GossipAlgorithm
  def of("push-sum"), do: PushSumAlgorithm

  @callback init_state(id :: integer()) :: any()

  @callback init_message(message :: string()) :: any()

  @callback process(message, state) :: {:continue, message, state} | {:terminate, state} when message: any(), state: any()

end
