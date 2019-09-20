defmodule Network do
  use Supervisor

  def start_link(nodes, topology, algorithm) do
    Agent.start_link(fn -> {nodes, 0, System.monotonic_time()} end, name: :global)
    workers = topology.get_neighbors(nodes)
              |> Enum.with_index()
              |> Enum.map(fn {neighbors, id} ->
      worker(Node, [id, neighbors, algorithm], [id: id])
    end)
    Supervisor.start_link(Network, [supervisor(Registry, [:unique, :registry]) | workers], name: :network)
    Node.send(0, algorithm.init_message("Hello there!"))
    run()
  end

  defp run(), do: run()

  def name(id), do: {:via, Registry, {:registry, id}}

  def terminate() do
    {nodes, visited, start} = Agent.get(:global, fn s -> s end)
    time = System.convert_time_unit(System.monotonic_time() - start, :native, :millisecond)
    IO.puts "#{100 * visited / nodes}% visited, #{time / 1000} seconds."
    System.stop(0)
  end

  def init(children), do: supervise(children, strategy: :one_for_one)

end
