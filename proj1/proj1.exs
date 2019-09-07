defmodule Parallel do
  def pmap(num_workers, func) do
    1 .. num_workers
    |> Enum.map(&(Task.async(fn -> func.(&1) end)))
    |> Enum.map(&Task.await/1)
  end
end

[lower, upper, num_workers] = Enum.map(System.argv, &String.to_integer/1)
total_size = Enum.count(lower..upper)
Parallel.pmap(num_workers, fn x ->
  starting = trunc(lower + ((x - 1) / num_workers) * total_size)
  ending = trunc(x / num_workers * total_size + lower - 1)
  Enum.each(
     starting .. ending,
      fn y ->
        # res =
          Proj1.Worker.ranged_search(y)
        # if ! Enum.empty?(res) do
        #   IO.puts Enum.join([y] ++ res, " ")
        # end
      end
  )
end)
