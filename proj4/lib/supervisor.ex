defmodule Proj4.Supervisor do
  use Supervisor


  def start_link do
    Supervisor.start_link(__MODULE__, [], name: :engine)
  end


  def start_node(username) do
    Supervisor.start_child(:engine, [username])
  end

  def init(_) do
    children = [
      worker(Proj4.Node, [])
    ]

    supervise(children, strategy: :simple_one_for_one)
  end

end
