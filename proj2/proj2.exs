[_nodes, topology, _algorithm] = System.argv
# IO.inspect NetworkTopology.get_neighbors(String.to_integer(nodes), topology)

Proj2.Registry.start_link

Proj2.Supervisor.start_link

Proj2.Supervisor.setup_nodes(topology)

Proj2.Node.update_state("node", %{s: 2, w: 2})

Proj2.Node.update_state("node", %{s: 2, w: 2})

Proj2.Node.send_message("node2")

res = Proj2.Node.get_state("node")

IO.inspect binding()
