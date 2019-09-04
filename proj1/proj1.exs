defmodule Proj1 do
  [lower, upper] = Enum.map(System.argv, &String.to_integer/1)

  coordinator_pid =
    spawn(Proj1.Coordinator, :loop, [[], Enum.count(lower..upper)])

  lower..upper |> Enum.each(fn number ->
    worker_pid = spawn(Proj1.Worker, :loop, [])
    send(worker_pid, {coordinator_pid, number})
  end)
end
