nodes = String.to_integer(Enum.at(System.argv, 0))
topology = Proj2.NetworkTopology.of(Enum.at(System.argv, 1))
algorithm = Proj2.NetworkAlgorithm.of(Enum.at(System.argv, 2))
Proj2.Network.start_link(nodes, topology, algorithm)
