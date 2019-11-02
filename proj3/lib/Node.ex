defmodule Proj3.Node do
  use GenServer
  use Bitwise

  def start_link(id) do
    GenServer.start_link(Proj3.Node, {id, %{}})
  end

  def insert(id, node, level), do: GenServer.cast(Proj3.Network.name(id), {:insert, node, level})

  def update(id, node, level), do: GenServer.cast(Proj3.Network.name(id), {:update, node, level})

  def next_hop(id, node, level), do: GenServer.call(Proj3.Network.name(id), {:next_hop, node, level})

  def print(id), do: GenServer.call(Proj3.Network.name(id), {:print})

  @impl GenServer
  def init(state) do
    IO.puts "NINJAS"
    {:ok, state}
  end

  @impl GenServer
  def handle_cast({:insert, node, level}, {id, routing_mesh}) do
    IO.puts "Update #{node}, #{level} @ #{id}"
    digit = Proj3.Network.digit_at(node, level)
    level_mesh = routing_mesh[level];
    entry = level_mesh[digit]
    level_mesh = cond do
      entry == nil ->
        Map.put(level_mesh, digit, node)
      node < entry ->
        update(entry, node, level)
        Map.put(level_mesh, digit, node)
      true ->
        insert(entry, node, level + 1)
        level_mesh
    end
    {:noreply, {id, Map.put(routing_mesh, level, level_mesh)}}
  end

  @impl GenServer
  def handle_cast({:update, node, level}, {id, routing_mesh}) do
    IO.puts "Update #{node}, #{level} @ #{id}"
    digit = Proj3.Network.digit_at(node, level)
    level_mesh = Map.put(routing_mesh[level], digit, node)
    update_internal(node, level, routing_mesh, level + 1)
    {:noreply, {id, Map.put(routing_mesh, level, level_mesh)}}
  end

  defp update_internal(node, level, routing_mesh, depth) do
    if depth != 4 do
      Enum.each(routing_mesh[depth], fn (_, id) -> update(id, node, level) end)
      update_internal(node, level, routing_mesh, depth + 1)
    else
      routing_mesh
    end
  end

  @impl GenServer
  def handle_call({:next_hop, node, level}, _from, {id, routing_mesh}) do
    if level == 4 do
      id
    else
      digit = (node >>> (16 - 4 * level)) &&& 0xF
      next_id = lookup(routing_mesh[level], digit)
      if next_id == id do
        {:reply, next_hop(next_id, node, level + 1), {id, routing_mesh}}
      else
        {:reply, next_id, {id, routing_mesh}}
      end
    end
  end

  @impl GenServer
  def handle_call({:print}, _from, {node_id, routing_mesh}) do
    IO.puts [node_id, routing_mesh]
  end

  defp lookup(table, digit) do
    case (table[digit]) do
      nil -> lookup(table, (digit + 1) &&& 0xF)
      res -> res
    end
  end

end
