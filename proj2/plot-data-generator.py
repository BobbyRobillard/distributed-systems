import subprocess
import re

topologies = [
    "full",
    "line",
    "rand2D",
    "3Dtorus",
    "honeycomb",
    "randhoneycomb"
]

algo = "gossip"

for t in topologies:
    print("\n_________________________\n\n {0} topology\n_________________________\n".format(t))
    for num_nodes in range(1, 250):
        time = subprocess.check_output(
            ["mix", "run", "proj2.exs", str(num_nodes), t, algo]
        )

        time = time.decode("utf-8").strip()

        print("{0}, {1}".format(str(num_nodes), time))
