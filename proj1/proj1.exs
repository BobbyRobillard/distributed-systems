# @TODO: Fix solution output
# @TODO: Divide and Conquer in supervisor
# @TODO: Add timing and documentation to readme


#################################################################################
#                Elixir script to get the ball rolling                          #
#################################################################################
# Take in system parameters
[lower, upper] = Enum.map(System.argv, &String.to_integer/1)

Proj1.Registry.start_link

Proj1.Supervisor.start_link

Enum.each(Proj1.Supervisor.solve_range(lower, upper), fn results ->
  Enum.each(results, fn result ->
    IO.puts(Enum.join(result, " "))
  end)
end)
