defmodule Proj4.Node do
  use GenServer

  # ----------------------------------------------------------------------------
  # Public API
  # ----------------------------------------------------------------------------

  def start_link(username) do
    # Init ETS for actor
    followers = :ets.new(:followers, [:set, :protected])

    tweets = :ets.new(:tweets, [:set, :protected])

    # Start Genserver holding user's state
    GenServer.start_link(
      __MODULE__,
      %{username: username, is_online: :false, followers: followers, tweets: tweets},
      name: via_tuple(username)
    )
  end

  defp via_tuple(username) do
    {:via, Proj4.Registry, {:node, username}}
  end

  def publish_tweet(username, tweet) do
    GenServer.cast(via_tuple(username), {:publish_tweet, tweet})
  end

  def get_tweets(username) do
    GenServer.call(via_tuple(username), :get_tweets)
  end

  # def follow_user(username, user_to_follow) do
  #   GenServer.cast(via_tuple(username), {:follow_user, username, user_to_follow})
  # end
  #
  # def retweet(username, tweet) do
  #   GenServer.cast(via_tuple(username), {:publish_tweet, tweet})
  # end
  #
  # def query_tweets(username, query) do
  #   GenServer.call(via_tuple(username), {:query_tweets, query})
  # end

  # ----------------------------------------------------------------------------
  # Internal API
  # ----------------------------------------------------------------------------

  # defp receive_tweet(username, tweet) do
  #   GenServer.cast(via_tuple(username), {:receive_tweet, tweet})
  # end
  #
  # defp handle_follow_from_user(username, username_of_follower) do
  #   GenServer.cast(via_tuple(username), {:handle_follow_from_user, user_to_follow})
  # end

  # ----------------------------------------------------------------------------
  # Cast/Calls
  # ----------------------------------------------------------------------------

  @impl GenServer
  def init(state) do
    {:ok, state}
  end

  @impl GenServer
  def handle_cast({:publish_tweet, tweet}, state) do
    # Map.get(state, :followers)
    # |> Enum.each(fn follower -> Proj4.Node.receive_tweet(follower, tweet) end)

    # Store tweet in our tweets only if it's not a re-tweet
    # if Map.get(tweet, :owner_username) == Map.get(state, username) do
    #   tweets = Map.get(state, :tweets) | tweet
    #   Map.put(state, :tweets, tweets)
    # end
    # tweets = Map.get(state, :tweets)
    :ets.insert_new(:tweets, {"123", tweet})
  end

  @impl GenServer
  def handle_call(:get_tweets, _from, state) do
    result = :ets.lookup(Map.get(state, :tweets), "123")
    {:ok, result, state}
  end

  # @impl GenServer
  # def handle_cast({:follow_user, username_of_follower, user_to_follow}) do
  #   # Add follower to other user's list of followers
  #   Proj4.Node.follow(user_to_follow, username_of_follower)
  # end
  #
  # @impl GenServer
  # def handle_cast({:receive_tweet, tweet}) do
  #   # Convert tweet into a user-friendly format
  #   user_friendly_tweet = "This is the user friendly tweet"
  #
  #   # Check if tweet is a retweet, updating user-friendly tweet as necessary
  #   if Map.get(tweet, :owner_username) != Map.get(state, username) do
  #     user_friendly_tweet = "This is retweeted userfriendly tweet"
  #   end
  #
  #   # Check if the tweet should be seen immediatley or sent to the user's mailbox
  #   if Map.get(state, is_online) == :true do
  #     IO.puts "Received Tweet"
  #   else
  #     new_mailbox = Map.get(state, :mailbox) | [user_friendly_tweet]
  #     Map.replace(state, :mailbox, new_mailbox)
  #   end
  # end
  #
  # @impl GenServer
  # def handle_call({:query_tweets, query}) do
  #   # Search all our tweets. See if the query is contained in the mentions, hashtags, or text of a tweet
  #   Map.get(state, :tweets)
  #   |> Enum.reduce(fn tweet, acc -> (if is_matching_tweet(tweet, query) do acc | [tweet] else acc end) end)
  # end



  # ----------------------------------------------------------------------------
  # Helper Methods
  # ----------------------------------------------------------------------------
  #
  # def is_matching_tweet(tweet, query) do
  #   # Search all mentions
  #   query_matches_mention = Map.get(tweet, :mentions)
  #   |> Enum.any?(fn mention -> mention == query end)
  #
  #   # Search all hashtags
  #   query_matches_hashtag = Map.get(tweet, :hashtags)
  #   |> Enum.any?(fn hashtag -> hashtag =~ query end)
  #
  #   # Search tweet text
  #   query_matches_text = Map.get(tweet, :text) =~ query
  #
  #   # Return result
  #   query_matches_mention or query_matches_hashtag or query_matches_text
  # end

end
