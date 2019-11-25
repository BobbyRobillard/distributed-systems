defmodule Proj4.Engine do

  def main() do
   IO.puts("Welcome to MEGA's Twitter Simulator!")
   print_help_message()
   receive_command()
 end

 @commands %{
   "quit" => "Exits twitter simulator",
   "register" => "Registers a twitter user",
   "reteet" => "Send a tweet from someone you follow to your followers",
   "tweet" => "Send out a tweet to your followers",
   "tweets" => "See all the tweets beloning to a user"
 }

 def retweet(username, tweet) do

 end

 defp receive_command do
   IO.gets("\n> ")
   |> String.trim
   |> String.downcase
   |> execute_command
 end

 defp execute_command("quit"), do: IO.puts "Exiting twitter!"

 defp execute_command("register") do
   username = IO.gets("\nEnter New Username> ") |> String.trim
   Proj4.Supervisor.register_user(username)
   IO.puts "User #{username} has been registered successfully"
   receive_command()
 end

 defp execute_command("retweet") do
   # IO.gets("\nEnter New Username> ") |> String.trim
   # Proj4.Supervisor.register_user(username)
   # IO.puts "User #{username} has been registered successfully"
   receive_command()
 end

 defp execute_command(_invalid_command), do: print_help_message()

 defp print_help_message do
   IO.puts("\nThe simulator supports following commands:\n")
   @commands
   |> Enum.map(fn({command, description}) -> IO.puts("  #{command} - #{description}") end)
 end

end
