defmodule Proj2.Supervisor do
  use Supervisor


  def start_link do
    Supervisor.start_link(__MODULE__, [], name: :node_supervisor)
  end


  def start_node(name) do
    Supervisor.start_child(:node_supervisor, [name])
  end


  def setup_nodes(_topology) do
    Proj2.Supervisor.start_node(1)
    Proj2.Supervisor.start_node(2)
    Proj2.Supervisor.start_node(3)
  end

  def init(_) do
    children = [
      worker(Proj2.Node, [])
    ]

    supervise(children, strategy: :simple_one_for_one)
  end

end
