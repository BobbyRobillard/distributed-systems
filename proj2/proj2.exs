nodes = String.to_integer(Enum.at(System.argv, 0))
topology = NetworkTopology.of(Enum.at(System.argv, 1))
algorithm = NetworkAlgorithm.of(Enum.at(System.argv, 2))
Network.start_link(nodes, topology, algorithm)
