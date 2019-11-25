defmodule Proj4.Engine do

  def main() do
   IO.puts("Welcome to the Toy Robot simulator!")
   print_help_message()
   receive_command()
 end

 @commands %{
   "quit" => "Exits twitter simulator",
   "register" => "Registers a twitter user",
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

 defp execute_command("quit") do
   IO.puts "Exiting twitter!"
 end

 defp execute_command(command) do
   case command do
     "register" -> username = IO.gets("\nEnter New Username> ") |> String.trim
                   Proj4.Supervisor.register_user(username)
                   IO.puts "User #{username} has been registered successfully"
     "tweets" -> name = IO.gets("\nEnter New Username> ")
                 Proj4.Node.get_tweets(name)
     _ -> print_help_message()
          IO.puts("\nInvalid command. I don't know what to do.")
   end

   receive_command()
 end

 defp print_help_message do
   IO.puts("\nThe simulator supports following commands:\n")
   @commands
   |> Enum.map(fn({command, description}) -> IO.puts("  #{command} - #{description}") end)
 end

end
