# Topologies

## Complete (full)

A graph where every node is connected to all other nodes.

## Linear (line)

A graph where every node is arranged linearly and connected to direct neighbors.

## RandPlanar (rand2D)

A graph where every node is randomly placed on a uniform plane and connected to
nodes within a certain distance.

## Cubic (3Dtorus)

A graph where nodes are arranged in cubic fashion and connected to neighbors,
including those passing to the other side of the cube.

The implementation generates {x, y, z} coordinates in the form of a 3D matrix.
Nodes are connected where two coordinates are the same and the other differs by
one or wraps around to the other side.

## Hexagonal (honeycomb)

A graph where nodes are arranged in a hexagonal grid and connected to neighbors.

The implementation generates {x, y} coordinates in a 'skewed' fashion, where the
x axis is horizontal and the y axis is slanted right. This calculates the
current ring of the hexagon (distance from center) and the normalized index
(index in current ring) and uses the current wedge to determine {x, y}. Nodes
are connected if the maximum distance along an {x, y, z} axis is one.

See <https://www.redblobgames.com/grids/hexagons/> for reference.

## RandHexagonal (randhoneycomb)

A graph where nodes are arranged in a hexagonal grid, as the above, and also
connected to a random node in the network.
