defmodule Proj1.Coordinator do

  def loop(results, expected) do
    receive do
      {:ok, result} ->
          new_results = [result | results]

          if expected == Enum.count(new_results) do
            IO.puts(results |> List.flatten |> Enum.join(" "))
          else
            loop(new_results, expected)
          end

       _ -> loop(results, expected)
    end
  end

end
