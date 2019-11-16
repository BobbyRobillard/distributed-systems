defmodule Proj4.Supervisor do
  use Supervisor


  def start_link do
    Supervisor.start_link(__MODULE__, [], name: :engine)
  end


  def start_node(username) do
    Supervisor.start_child(:engine, [username])
  end


  def demo do
    Proj4.Supervisor.start_node("worker1")

    Proj4.Node.publish_tweet("worker1", "maga")

    Proj4.Node.get_tweets("worker1")
    |> Enum.each(fn x -> IO.puts Enum.at(Tuple.to_list(x), 1)  end)
  end

  def init(_) do
    children = [
      worker(Proj4.Node, [])
    ]

    supervise(children, strategy: :simple_one_for_one)
  end

end
