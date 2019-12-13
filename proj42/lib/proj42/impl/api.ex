defmodule Proj42.Impl.Api do

  def users() do #{:ok, list[string]}
    {:ok, Proj42.Impl.Registry.get_all()}
  end

  def register(username) do #{:ok}
    case Proj42.Impl.Supervisor.register_user(username) do
      {:ok, _} -> {:ok}
      error -> error
    end
  end

  def login(username, password) do #{:ok}
    Proj42.Impl.Node.set_status(username, :online)
    {:ok}
  end

  def logout(username) do #{:ok}
    Proj42.Impl.Node.set_status(username, :offline)
    {:ok}
  end

  def status(username) do #{:ok, :online|:offline}
    {:ok, Proj42.Impl.Node.get_status(username)}
  end

  def follow(username, other) do #{:ok}
    Proj42.Impl.Node.follow_user(username, other)
    {:ok}
  end

  def unfollow(username, other) do #{:ok}
    Proj42.Impl.Node.unfollow_user(username, other)
    {:ok}
  end

  def following(username) do #{:ok, following: list[string]}
    {:ok, Proj42.Impl.Node.get_following(username)}
  end

  def followers(username) do #{:ok, followers: list[string]}
    {:ok, Proj42.Impl.Node.get_followers(username)}
  end

  def tweet(username, message) do #{:ok}
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
    Proj42.Impl.Node.publish_tweet(username, tweet)
    {:ok}
  end

  def tweets(username) do #{:ok, tweets: list[string]}
    {:ok, Proj42.Impl.Node.get_tweets(username)}
  end

  def query(username, query, neighbors \\ false) do #{:ok, tweets: list[tweet: map]}
    {:ok, Proj42.Impl.Node.query_tweets(username, query, neighbors)}
  end

end