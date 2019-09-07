defmodule Server do
  use GenServer

  def init() do
    GenServer.start_link(__MODULE__, [])
  end

  def report(number, fangs) do
    GenServer.cast({:report, number, fangs});
  end

  def print() do
    GenServer.cast(:print);
  end

  @impl true
  def init(state) do
    {:ok, state}
  end

  @impl true
  def handle_cast({:report, number, fangs}, state) do
    state = case fangs do
      [] -> state
      fangs -> [[number | fangs] | state]
    end
    {:noreply, state}
  end

  @impl true
  def handle_cast(:print, state) do
    state |> Enum.each(fn result -> result |> Enum.join(" ") |> IO.puts end)
    {:noreply, []}
  end

end
