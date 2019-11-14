defmodule Proj3.Main do

  def main(args \\ []) do
    nodes = String.to_integer(Enum.at(args, 0))
    children = [
      {Proj3.Network, []},
      {Registry, [keys: :unique, name: :registry]}
    ]
    Supervisor.start_link(children, [strategy: :one_for_one, name: Proj3.Main])
    ids = Enum.map(1..nodes, fn _ -> Proj3.Network.start_node(Proj3.Network.gen_id()) end)
    Enum.each(1..nodes, fn _ -> Proj3.Network.lookup(Enum.random(ids), Proj3.Network.gen_id()) end)
    IO.puts "Total number of hops = #{Agent.get(:hops, & &1)}"
    #test_ids = [0x1600, 0x2B00, 0x1F00, 0x1100, 0x1200, 0x1B00]
    #Enum.each(test_ids, fn id ->
    #  Proj3.Network.start_node(id)
    #  Proj3.Node.insert(-1, id, 1)
    #end)
    #Enum.each(test_ids, fn id -> Proj3.Node.print(id) end)
    #IO.inspect(Proj3.Network.lookup(0x1600, 0x1900), base: :hex)
    #IO.inspect(Proj3.Network.lookup(0x1600, 0x2B00), base: :hex)
    #IO.inspect(Proj3.Network.lookup(0x1600, 0x3000), base: :hex)
    #IO.inspect(Proj3.Network.lookup(0x1600, 0x1111), base: :hex)
    run()
  end

  def run(), do: run()

end
