defmodule Proj3.Node do
  use GenServer
  use Bitwise

  def start_link(id), do: GenServer.start_link(__MODULE__, id, name: Proj3.Network.name(id))

  def insert(id, node, level), do: GenServer.cast(Proj3.Network.name(id), {:insert, node, level})

  def init_mesh(id, level, mesh), do: GenServer.cast(Proj3.Network.name(id), {:init_mesh, level, mesh})

  def update(id, node, level), do: GenServer.cast(Proj3.Network.name(id), {:update, node, level})

  def next_hop(id, node, level), do: GenServer.call(Proj3.Network.name(id), {:next_hop, node, level})

  def print(id), do: GenServer.cast(Proj3.Network.name(id), {:print})

  @impl GenServer
  def init(id) do
    {:ok, {id, %{
      1 => %{},
      2 => %{},
      3 => %{},
      4 => %{}
    }}}
  end

  @impl GenServer
  def handle_cast({:insert, node, level}, {id, routing_mesh}) do
    Agent.update(:hops, fn h -> h + 1 end)
    digit = Proj3.Network.digit_at(node, level)
    level_mesh = routing_mesh[level];
    entry = level_mesh[digit]
    level_mesh = cond do
      entry == nil ->
        Map.put(level_mesh, digit, node)
      node < entry ->
        Map.put(level_mesh, digit, node)
      true ->
        insert(entry, node, level + 1)
        level_mesh
    end
    init_mesh(node, level, Map.delete(level_mesh, digit))
    if entry != nil and node < entry do
      update(entry, node, level)
    end
    {:noreply, {id, Map.put(routing_mesh, level, level_mesh)}}
  end

  def handle_cast({:init_mesh, level, mesh}, {id, routing_mesh}) do
    {:noreply, {id, Map.put(routing_mesh, level, mesh)}}
  end

  @impl GenServer
  def handle_cast({:update, node, level}, {id, routing_mesh}) do
    Agent.update(:hops, fn h -> h + 1 end)
    digit = Proj3.Network.digit_at(node, level)
    level_mesh = Map.put(routing_mesh[level], digit, node)
    routing_mesh = update_internal(id, node, level, routing_mesh, level + 1)
    {:noreply, {id, Map.put(routing_mesh, level, level_mesh)}}
  end

  defp update_internal(id, node, level, routing_mesh, depth) do
    if depth != 4 do
      Enum.each(routing_mesh[depth], fn {_, i} ->
        if i != id do
          Agent.update(:hops, fn h -> h + 1 end)
          Proj3.Node.update(id, node, level)
        end
      end)
      update_internal(id, node, level, routing_mesh, depth + 1)
    else
      routing_mesh
    end
  end

  @impl GenServer
  def handle_call({:next_hop, node, level}, _from, {id, routing_mesh}) do
    Agent.update(:hops, fn h -> h + 1 end)
    if level == 4 do
      id
    else
      digit = (node >>> (16 - 4 * level)) &&& 0xF
      next_id = lookup(routing_mesh[level], digit)
      if next_id != nil and next_id != id do
        {:reply, next_hop(next_id, node, level + 1), {id, routing_mesh}}
      else
        {:reply, id, {id, routing_mesh}}
      end
    end
  end

  @impl GenServer
  def handle_cast({:print}, {node_id, routing_mesh}) do
    IO.inspect([node_id, routing_mesh], pretty: true, base: :hex, width: 20)
    {:noreply, {node_id, routing_mesh}}
  end

  defp lookup(table, digit) do
    if Enum.empty?(table) do
      nil
    else
      case (table[digit]) do
        nil -> lookup(table, (digit + 1) &&& 0xF)
        res -> res
      end
    end
  end

end
