defmodule NodeTest do
  use ExUnit.Case
  @moduletag :capture_log

  # ----------------------------------------------------------------------
  # Helper functions for test functionality
  # ----------------------------------------------------------------------

  setup do
    # Restart the application to force close any GenServer state
    Application.stop(:proj4)
    :ok = Application.start(:proj4)
    # Starts supervisors under ExUnit to manage proper teardown
    start_supervised!(Proj4.Registry)
    start_supervised!(Proj4.Supervisor)
    []
  end

  defp init(env) do
    Enum.each(env, fn {user, _} -> Proj4.Supervisor.register_user(user) end)
    Enum.each(env, fn {user, followers} ->
      Enum.each(followers, fn f -> Proj4.Node.follow_user(user, f) end)
    end)
  end

  test "init" do
    init(%{a: [:b], b: []})
    assert 1 == Proj4.Node.get_following(:a) |> Enum.count
    assert 0 == Proj4.Node.get_followers(:a) |> Enum.count
    assert 0 == Proj4.Node.get_following(:b) |> Enum.count
    assert 1 == Proj4.Node.get_followers(:b) |> Enum.count
  end

  test "status" do
    init(%{a: []})
    assert :online == Proj4.Node.get_status(:a)

    # Change status to offline
    Proj4.Node.set_status(:a, :offline)
    assert :offline == Proj4.Node.get_status(:a)

    # Change status to online
    Proj4.Node.set_status(:a, :online)
    assert :online == Proj4.Node.get_status(:a)
  end

  # ----------------------------------------------------------------------

  # @# TODO:
  # test "Receive Tweet Functionality" do
  #
  # end

  # ----------------------------------------------------------------------

  test "publish" do
    init(%{a: [:b], b: []})
    assert 0 == Proj4.Node.get_tweets(:a) |> Enum.count

    # Publish and retrieve tweet
    tweet = %{
      content: "Trump for president!",
      mentions: ["trump"],
      hashtags: ["maga", "2020"]
    }
    Proj4.Node.publish_tweet(:a, tweet)
    tweets = Proj4.Node.get_tweets(:a)
    assert 1 == Enum.count(tweets)
    assert tweet == hd(tweets)
  end

  # ----------------------------------------------------------------------

  test "follow" do
    init(%{a: [], b: [], c: []})
    assert 0 == Proj4.Node.get_following(:a) |> Enum.count
    assert 0 == Proj4.Node.get_followers(:a) |> Enum.count

    # Test Adding A Follower
    Proj4.Node.follow_user(:a, :b)
    assert 1 == Proj4.Node.get_following(:a) |> Enum.count
    assert 0 == Proj4.Node.get_followers(:a) |> Enum.count
    assert 0 == Proj4.Node.get_following(:b) |> Enum.count
    assert 1 == Proj4.Node.get_followers(:b) |> Enum.count

    # Make sure followers can't be added twice
    Proj4.Node.follow_user(:a, :b)
    assert 1 == Proj4.Node.get_following(:a) |> Enum.count

    # Add another follower
    Proj4.Node.follow_user(:a, :c)
    assert 2 == Proj4.Node.get_following(:a) |> Enum.count
    assert 1 == Proj4.Node.get_followers(:c) |> Enum.count

    # Test removing a follower
    Proj4.Node.unfollow_user(:a, :c)
    assert 1 == Proj4.Node.get_following(:a) |> Enum.count
    assert 0 == Proj4.Node.get_followers(:c) |> Enum.count

    # Remove a follower which isn't following
    Proj4.Node.unfollow_user(:a, :c)
    assert 1 == Proj4.Node.get_following(:a) |> Enum.count
    assert 0 == Proj4.Node.get_followers(:c) |> Enum.count
  end

  # ----------------------------------------------------------------------

  test "query" do
    init(%{a: [], b: [:a]})
    tweet = %{
      content: "Trump for president!",
      mentions: ["Trump"],
      hashtags: ["MAGA", "2020"]
    }
    Proj4.Node.publish_tweet(:a, tweet)
    assert 1 == Proj4.Node.query_tweets(:a, "trump") |> Enum.count()
    assert 1 == Proj4.Node.query_tweets(:b, "trump") |> Enum.count()
    assert 1 == Proj4.Node.query_tweets(:a, "maga") |> Enum.count()
    assert 0 == Proj4.Node.query_tweets(:a, "hillary") |> Enum.count()
  end

end
