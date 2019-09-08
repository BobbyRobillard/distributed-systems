#################################################################################
#                Elixir script to get the ball rolling                          #
#################################################################################
# Take in system parameters
[lower, upper] = Enum.map(System.argv, &String.to_integer/1)

Proj1.Registry.start_link

Proj1.Supervisor.start_link

solutions = Proj1.Supervisor.solve_range(lower..upper)

IO.inspect binding()

# # @TODO: Fix solution output
# solutions
# |> Enum.each(
#   fn solution ->
#     IO.inspect binding()
#     # IO.puts Enum.join(solution, " ")
#   end
# )
