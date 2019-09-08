defmodule Proj1.Supervisor do
  use Supervisor


  def start_link do
    Supervisor.start_link(__MODULE__, [], name: :vampire_supervisor)
  end


  def start_worker(name) do
    Supervisor.start_child(:vampire_supervisor, [name])
  end


  def init(_) do
    children = [
      worker(Proj1.Worker, [])
    ]

    supervise(children, strategy: :simple_one_for_one)
  end


  # @impl true
  # def handle_cast(:print, state) do
  #   state |> Enum.each(fn result -> result |> Enum.join(" ") |> IO.puts end)
  #   {:noreply, []}
  # end

end
