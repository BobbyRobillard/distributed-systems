[_nodes, topology, _algorithm] = System.argv
# IO.inspect NetworkTopology.get_neighbors(String.to_integer(nodes), topology)

# Proj2.Topology.RandPlanarTopology.get_neighbors(3)

Proj2.Registry.start_link
#
Proj2.Supervisor.start_link
#
Proj2.Supervisor.setup_nodes(topology)
#
Proj2.Node.demo(1, "It Worked")
Proj2.Node.demo(2, "It Worked")
Proj2.Node.demo(3, "It Worked")
