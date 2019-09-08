defmodule Proj1.Supervisor do
  use Supervisor


  def start_link do
    Supervisor.start_link(__MODULE__, [], name: :vampire_supervisor)
  end


  def start_worker(name) do
    Supervisor.start_child(:vampire_supervisor, [name])
  end


  def solve_range(range) do
    Proj1.Supervisor.start_worker("worker1")
    Proj1.Supervisor.start_worker("worker2")
    Proj1.Supervisor.start_worker("worker3")

    Proj1.Worker.solve_range("worker1", range)
    Proj1.Worker.solve_range("worker2", range)
    Proj1.Worker.solve_range("worker3", range)

    solutions = [
      Proj1.Worker.get_solutions("worker1"),
      Proj1.Worker.get_solutions("worker2"),
      Proj1.Worker.get_solutions("worker3")
    ]
  end


  def init(_) do
    children = [
      worker(Proj1.Worker, [])
    ]

    supervise(children, strategy: :simple_one_for_one)
  end

end
