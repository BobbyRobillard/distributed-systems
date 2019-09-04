defmodule Proj1.Coordinator do

  def loop(results, remaining) do
    receive do
      {:ok, result} ->
        results = case result do
          [_] -> results
          _ -> [result | results]
        end

        if remaining > 1 do
          loop(results, remaining - 1)
        else
          Enum.each(results, fn result ->
            IO.puts(Enum.join(result, " "))
          end)
        end

       _ -> loop(results, remaining)
    end
  end

end
