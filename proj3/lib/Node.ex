defmodule Proj3.Node do
  use GenServer
  use Bitwise

  def start_link(id) do
    GenServer.start_link(Proj3.Node, {id, %{}})
  end

  def next_hop(id, level), do: GenServer.call(Proj3.Network.name(id), {:next_hop, id, level})

  @impl GenServer
  def init(state), do: {:ok, state}

  @impl GenServer
  def handle_call({:next_hop, id, level}, {node_id, routing_mesh}) do
    if level == 4 do
      node_id
    else
      digit = (id >>> (16 - 4 * level)) &&& 0xF
      next_id = lookup(routing_mesh[level], digit)
      if next_id == node_id do
        {:reply, next_hop(id, level + 1), {node_id, routing_mesh}}
      else
        {:reply, next_id, {node_id, routing_mesh}}
      end
    end
  end

  defp lookup(table, digit) do
    case (table[digit]) do
      nil -> lookup(table, (digit + 1) &&& 0xF)
      res -> res
    end
  end

end
