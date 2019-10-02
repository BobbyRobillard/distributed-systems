defmodule Proj2.NetworkAlgorithm do

  def of("gossip"), do: Proj2.GossipAlgorithm
  def of("push-sum"), do: Proj2.PushSumAlgorithm

  @callback init_state(id :: integer()) :: any()

  @callback init_message(message :: string()) :: any()

  @callback process(message, state) :: {:continue, message, state} | {:terminate, state} when message: any(), state: any()

end
