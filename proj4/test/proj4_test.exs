defmodule Proj4Test do
  use ExUnit.Case
  import ExUnit.CaptureIO

  # ----------------------------------------------------------------------
  # Helper functions for test functionality
  # ----------------------------------------------------------------------

  def start_up do
      [
        Proj4.Registry.start_link(),
        Proj4.Supervisor.start_link()
      ]
  end

  def add_nodes do
    Enum.reduce(
      1..10,
      [],
      fn id, acc -> acc ++ [Proj4.Supervisor.register_user(Integer.to_string(id))] end
    )
  end

  # ----------------------------------------------------------------------

  # Make sure the startup result of all supervisors/registrys is :ok.
  test "program startup" do
    start_up()
    |> Enum.each(fn result ->
          result =
          Tuple.to_list(result)
          |> Enum.at(0)

          assert result == :ok
       end)
  end

  # ----------------------------------------------------------------------

  # Make sure nodes can be added to the network.
  test "node initialization" do
    Proj4.Registry.start_link()
    supervisor_pid = Proj4.Supervisor.start_link()
    |> elem(1)

    add_nodes()

    assert 10 == Supervisor.count_children(supervisor_pid)[:active]
  end

  # ----------------------------------------------------------------------

  # @# TODO:
  # test "Receive Tweet Functionality" do
  #
  # end

  # ----------------------------------------------------------------------

  test "Publish Tweet Functionality" do
    start_up()
    add_nodes()

    publishing_node_id = "1"

    tweet = %{
      hashtags: ["trump", "america"],
      mentions: ["obama"],
      content: "abc123"
    }

    Proj4.Node.publish_tweet(publishing_node_id, tweet)

    num_tweets = Proj4.Node.get_tweets(publishing_node_id)
    |> Enum.count

    # Make sure publisher properly stored tweets,
    assert num_tweets == 1
  end

  # ----------------------------------------------------------------------

  test "Follow a User Functionality" do
    start_up()
    add_nodes()

    # Test Adding A Follower
    Proj4.Node.follow_user("2", "1")
    assert (Proj4.Node.get_followers("1") |> Enum.count()) == 1

    # Make sure followers can't be added twice
    Proj4.Node.follow_user("2", "1")
    assert (Proj4.Node.get_followers("1") |> Enum.count()) == 1

    # Add another follower
    Proj4.Node.follow_user("3", "1")
    assert (Proj4.Node.get_followers("1") |> Enum.count()) == 2

    # Test removing a follower
    Proj4.Node.unfollow_user("2", "1")
    assert (Proj4.Node.get_followers("1") |> Enum.count()) == 1

    # Remove a follower which isn't following
    Proj4.Node.unfollow_user("2", "1")
    assert (Proj4.Node.get_followers("1") |> Enum.count()) == 1
  end

  # ----------------------------------------------------------------------

  test "Query Tweets Functionality" do
    start_up()
    add_nodes()

    # Follow Users
    Proj4.Node.follow_user("2", "1")
    Proj4.Node.follow_user("3", "1")
    Proj4.Node.follow_user("3", "2")


    tweet = %{
      hashtags: ["trump", "america"],
      mentions: ["obama"],
      content: "Trump for president!"
    }

    Proj4.Node.publish_tweet("1", tweet)
    Proj4.Node.publish_tweet("2", tweet)

    assert (Proj4.Node.query_tweets("1", "trump") |> Enum.count()) == 1

    assert (Proj4.Node.query_tweets("1", "hillary") |> Enum.count()) == 0

  end

  # ----------------------------------------------------------------------
  test "Register User Functionality" do
    start_up()
  end

end
