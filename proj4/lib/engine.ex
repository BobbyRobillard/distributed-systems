defmodule Proj4.Engine do

  def main() do
    IO.puts("Welcome to MEGA's Twitter Simulator!")
    Proj4.Registry.start_link([])
    Proj4.Supervisor.start_link([])
    Agent.start_link(fn -> nil end, name: :active_user)
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
            "logon <username>: Sets status as online and changes the active user.",
            "logoff: Sets status as offline and remove the active user.",
            "status: View a user's status.",
            "follow <user>: Follow another user.",
            "unfollow <user>: Unfollow another user.",
            "following: View who a user is following.",
            "followers: View a user's followers.",
            "tweet <message>: Tweets a message.",
            "tweets: View a user's tweets.",
            "query <query>: Query a user's tweets",
            "quit: Exits program.",
          ] |> Enum.join("\n")
    }
  end

  def execute(["register", username]) do
    Agent.update(:active_user, fn _ -> username end)
    Proj4.Supervisor.register_user(username)
    {:ok, "#{username} registered successfully."}
  end

  def execute(["logon", username]) do
    Agent.update(:active_user, fn _ -> username end)
    Proj4.Node.set_status(username, :online)
    {:ok, "#{username} has logged on."}
  end

  def execute(["logoff"]) do
    username = active_user()
    Proj4.Node.set_status(username, :offline)
    {:ok, "#{username} has logged off."}
  end

  def execute(["status"]) do
    username = active_user()
    status = Proj4.Node.get_status(username)
    {:ok, "#{username} is currently #{Atom.to_string(status)}."}
  end

  def execute(["follow", user]) do
    username = active_user()
    Proj4.Node.follow_user(username, user)
    {:ok, "#{username} is now following #{user}."}
  end

  def execute(["unfollow", user]) do
    username = active_user()
    Proj4.Node.unfollow_user(username, user)
    {:ok, "#{username} is no longer following #{user}."}
  end

  def execute(["following"]) do
    {:ok, Proj4.Node.get_following(active_user()) |> Enum.join("\n")}
  end

  def execute(["followers"]) do
    {:ok, Proj4.Node.get_followers(active_user()) |> Enum.join("\n")}
  end

  def execute(["tweet", content]) do
    words = String.split(content, " ")
    tweet = %{
      content: content,
      mentions: words
        |> Enum.filter(fn s -> String.starts_with?(s, "@") end)
        |> Enum.map(fn s -> String.slice(s, 1..0) end),
      hashtags: words
        |> Enum.filter(fn s -> String.starts_with?(s, "@") end)
        |> Enum.map(fn s -> String.slice(s, 1..0) end)
    }
    Proj4.Node.publish_tweet(active_user(), tweet)
    {:ok, "Tweet published successfully."}
  end

  def execute(["tweets"]) do
    tweets = Proj4.Node.get_tweets(active_user())
      |> Enum.map(fn t -> t[:content] end)
      |> Enum.join("\n")
    {:ok, if tweets == "" do "No tweets." else tweets end}
  end

  def execute(["query", query]) do
    tweets = Proj4.Node.query_tweets(active_user(), query)
      |> Enum.map(fn t -> t[:content] end)
      |> Enum.join("\n")
    {:ok, if tweets == "" do "No results." else tweets end}
  end

  def execute(["quit"]), do: {:quit}

  def execute(_), do: {:error, "Invalid command (run 'help' for commands)."}

  defp active_user(), do: Agent.get(:active_user, fn u -> u end)

end
