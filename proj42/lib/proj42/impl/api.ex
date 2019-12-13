defmodule Proj42.Impl.Api do

  def users() do #{:ok, list[string]}
    {:error, "TODO"}
  end

  def register(username) do #{:ok}
    {:error, "TODO"}
  end

  def login(username, password) do #{:ok}
    {:error, "TODO"}
  end

  def logout(username) do #{:ok}
    {:error, "TODO"}
  end

  def status(username) do #{:ok, :online|:offline}
    {:error, "TODO"}
  end

  def follow(username, other) do #{:ok}
    {:error, "TODO"}
  end

  def unfollow(username, other) do #{:ok}
    {:error, "TODO"}
  end

  def following(username) do #{:ok, following: list[string]}
    {:error, "TODO"}
  end

  def followers(username) do #{:ok, followers: list[string]}
    {:error, "TODO"}
  end

  def tweet(username, message) do #{:ok}
    {:error, "TODO"}
  end

  def tweets(username) do #{:ok, tweets: list[string]}
    {:error, "TODO"}
  end

  def query(username, query, neighbors \\ false) do #{:ok, tweets: list[tweet: map]}
    {:error, "TODO"}
  end

end