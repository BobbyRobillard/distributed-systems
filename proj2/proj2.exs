[nodes, topology, algorithm] = System.argv
IO.inspect NetworkTopology.get_neighbors(String.to_integer(nodes), topology)
