defmodule Proj2.Main do

  def main(args \\ []) do
    nodes = String.to_integer(Enum.at(args, 0))
    topology = Proj2.NetworkTopology.of(Enum.at(args, 1))
    algorithm = Proj2.NetworkAlgorithm.of(Enum.at(args, 2))
    Proj2.Network.start_link(nodes, topology, algorithm)
  end

end
