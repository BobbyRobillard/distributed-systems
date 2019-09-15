[_nodes, topology, _algorithm] = System.argv
# IO.inspect NetworkTopology.get_neighbors(String.to_integer(nodes), topology)

# Proj2.Topology.RandPlanarTopology.get_neighbors(3)

Proj2.Registry.start_link
#
Proj2.Supervisor.start_link
#
Proj2.Supervisor.setup_nodes(topology)
#
Proj2.Node.update_state("node", %{s: 2, w: 2})
#
Proj2.Node.update_state("node", %{s: 2, w: 2})
#
res = Proj2.Node.get_state("node2")

Proj2.Node.send_message("node", "node2")

res2 = Proj2.Node.get_state("node")


res3 = Proj2.Node.get_state("node2")

IO.inspect binding()
