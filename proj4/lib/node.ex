defmodule Proj4.Node do
  use GenServer

  # ----------------------------------------------------------------------------
  # Public API
  # ----------------------------------------------------------------------------

  def start_link(username) do
    GenServer.start_link(__MODULE__, [username], name: via_tuple(username))
  end

  defp via_tuple(username) do
    {:via, Proj4.Registry, {:node, username}}
  end

  def publish_tweet(username, tweet) do
    GenServer.cast(via_tuple(username), {:publish_tweet, tweet})
  end

  def receive_tweet(username, tweet) do
    GenServer.cast(via_tuple(username), {:receive_tweet, tweet})
  end

  def get_tweets(username) do
    GenServer.call(via_tuple(username), :get_tweets)
  end

  def add_follower(username, follower) do
    GenServer.cast(via_tuple(username), {:add_follower, follower})
  end

  def remove_follower(username, follower) do
    GenServer.cast(via_tuple(username), {:remove_follower, follower})
  end

  def get_followers(username) do
    GenServer.call(via_tuple(username), :get_followers)
  end

  # def follow_user(username, user_to_follow) do
  #   GenServer.cast(via_tuple(username), {:follow_user, username, user_to_follow})
  # end
  #
  # def retweet(username, tweet) do
  #   GenServer.cast(via_tuple(username), {:publish_tweet, tweet})
  # end

  def query_tweets(username, query) do
    GenServer.call(via_tuple(username), {:query_tweets, query})
  end

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
  def init(username) do
    tweets = :ets.new(:tweets, [:set, :private])
    followers = :ets.new(:followers, [:set, :private])
    {:ok, %{
      username: username,
      tweets: tweets,
      followers: followers
    }}
  end

  @impl GenServer
  def handle_cast({:publish_tweet, tweet}, state) do
    # Send tweet to all our followers
    # Store tweet in our tweets only if it's not a re-tweet
    :ets.insert(state[:tweets], {tweet})
    broadcast_tweet(tweet, state[:followers], :ets.first(state[:followers]))
    {:noreply, state}
  end

  defp broadcast_tweet(_tweet, _followers, :"$end_of_table"), do: nil
  defp broadcast_tweet(tweet, followers, key) do
    IO.puts "Broadcast to #{key}"
    receive_tweet(key, tweet)
    broadcast_tweet(tweet, followers, :ets.next(followers, key))
  end

  @impl GenServer
  def handle_cast({:receive_tweet, tweet}, state) do
    IO.puts "#{state[:username]} received tweet: #{tweet[:content]}"
    {:noreply, state}
  end

  @impl GenServer
  def handle_call(:get_tweets, _from, state) do
    {:reply, (Map.get(state, :tweets) |> :ets.tab2list), state}
  end

  @impl GenServer
  def handle_cast({:add_follower, follower}, state) do
    :ets.insert(state[:followers], {follower})
    {:noreply, state}
  end

  @impl GenServer
  def handle_cast({:remove_follower, follower}, state) do
    :ets.delete(state[:followers], follower)
    {:noreply, state}
  end

  @impl GenServer
  def handle_call(:get_followers, _from, state) do
    {:reply, (Map.get(state, :followers) |> :ets.tab2list), state}
  end

  @impl GenServer
  def handle_call({:query_tweets, query}, _from, state) do
    # Search all our tweets. See if the query is contained in the mentions, hashtags, or text of a tweet
    Map.get(state, :tweets)
    |> Enum.reduce(fn tweet, acc -> (if is_matching_tweet(tweet, query) do acc ++ [tweet] else acc end) end)

    # Search the tweets of all our followers
  end



  # ----------------------------------------------------------------------------
  # Helper Methods
  # ----------------------------------------------------------------------------

  def is_matching_tweet(tweet, query) do
    # Search all mentions
    query_matches_mention = Map.get(tweet, :mentions)
    |> Enum.any?(fn mention -> mention == query end)

    # Search all hashtags
    query_matches_hashtag = Map.get(tweet, :hashtags)
    |> Enum.any?(fn hashtag -> hashtag =~ query end)

    # Search tweet text
    query_matches_text = Map.get(tweet, :content) =~ query

    # Return result
    query_matches_mention or query_matches_hashtag or query_matches_text
  end

end
