defmodule Proj1.Coordinator do

  def loop(results, expected) do
    receive do
      {:ok, result} ->
          new_results = [result | results]

          if expected == Enum.count(new_results) do
            send self(), :exit
          end

          loop(new_results, expected)

      :exit ->
        IO.puts(results |> List.flatten |> Enum.join(" "))

       _ -> loop(results, expected)
    end
  end

end
