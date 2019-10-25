defmodule Proj3.Main do

  def main(args \\ []) do
    nodes = String.to_integer(Enum.at(args, 0))
    Proj3.Network.start_link(nodes)
  end

end
