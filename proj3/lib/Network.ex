defmodule Proj3.Network do
  use DynamicSupervisor
  use Bitwise

  def name(id), do: {:via, Registry, {:registry, id}}

  def gen_id(), do: :rand.uniform(0x10000) - 1

  def digit_at(id, level), do: (id >>> (16 - 4 * level)) &&& 0xF

  def start_link(_) do
    DynamicSupervisor.start_link(__MODULE__, [], name: __MODULE__)
    Agent.start_link(fn -> %{} end, name: :roots)
    Agent.start_link(fn -> 0 end, name: :hops)
  end

  def start_node(id) do
    DynamicSupervisor.start_child(Proj3.Network, %{
      id: Proj3.Node,
      start: {Proj3.Node, :start_link, [id]},
      restart: :transient
    })
    Agent.update(:roots, fn roots ->
      digit = digit_at(id, 1)
      case roots[digit] do
        nil ->
          Proj3.Node.init_mesh(id, 1, roots)
          Enum.each(roots, fn {_, i} ->
            Proj3.Node.update(i, id, 1)
          end)
          Map.put(roots, digit, id)
        node ->
          Proj3.Node.insert(node, id, 1)
          if id < node do
            Map.put(roots, digit, id)
          else
            roots
          end
      end
    end)
    id
  end

  def lookup(from, to) do
    Proj3.Node.next_hop(from, to, 1)
  end

  @impl DynamicSupervisor
  def init(_), do: DynamicSupervisor.init(strategy: :one_for_one)

end
