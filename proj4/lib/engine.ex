defmodule Proj4.Engine do

  def main() do
    IO.puts("Welcome to MEGA's Twitter Simulator!")
    process()
  end

  def process() do
    case execute(IO.gets("> ") |> String.trim |> String.split(" ", parts: 2)) do
      {:ok, message} ->
        IO.puts(message)
        process()
      {:error, message} ->
        IO.puts("Error processing command: #{message}")
        process()
      {:quit} -> nil
    end
  end

  def execute(["help"]) do
    {:ok, [
            "help: View available commands.",
            "register <username>: Registers a Twitter user.",
            "logon <username>: Sets status as online.",
            "logoff <username>: Sets status as offline.",
            "tweet <username> <message>: Tweets a message.",
            "tweets <username>: View a users tweets.",
            "quit: Exits program.",
          ] |> Enum.join("\n")
    }
  end

  def execute(["register", username]) do
    Proj4.Supervisor.register_user(username)
    {:ok, "User #{username} registered successfully."}
  end

  def execute(["logon", username]) do
    Proj4.Node.set_status(username, :online)
    {:ok, "User #{username} has logged on."}
  end

  def execute(["logoff", username]) do
    Proj4.Node.set_status(username, :offline)
    {:ok, "User #{username} has logged off."}
  end

  def execute(["tweet", _message]) do
    {:error, "Command 'tweet' not implemented."}
  end

  def execute(["tweets", _username]) do
    {:error, "Command 'tweets' not implemented."}
  end

  def execute(["quit"]), do: {:quit}

  def execute(_), do: {:error, "Invalid command (run 'help' for commands)."}

end
