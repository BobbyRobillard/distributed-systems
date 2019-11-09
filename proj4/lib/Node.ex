defmodule Proj4.Node do
  use GenServer

  # ----------------------------------------------------------------------------
  # API
  # ----------------------------------------------------------------------------

  def start_link(username) do
    GenServer.start_link(__MODULE__, {id, %{username: username, tweets: [], followers: []}}, name: via_tuple(name))
  end

  def publish_tweet(username, tweet) do
    GenServer.cast(via_tuple(username), {:publish_tweet, tweet})
  end

  def follow_user(username, user_to_follow) do
    GenServer.cast(via_tuple(username), {:follow_user, username, user_to_follow})
  end

  def retweet(username, tweet_owner, tweet_id) do
    tweet = Proj4.Node.get_tweet(tweet_owner, tweet_id)
    GenServer.cast(via_tuple(username), {:retweet, tweet})
  end

  def query_tweets(username, query) do
    GenServer.call(via_tuple(username), {:query_tweets, query})
  end

  # ----------------------------------------------------------------------------
  # Cast/Calls
  # ----------------------------------------------------------------------------

  @impl GenServer
  def init(state) do
    {:ok, state}
  end

  @impl GenServer
  def handle_cast({:follow_user, username, user_to_follow}) do
    # Add follower to other user's list of followers
    Proj4.Node.send(user_to_follow, :follow, username)
  end

  @impl GenServer
  def handle_cast({:retweet, tweet}) do
    # Publish tweet to all followers
    Map.get(state, :followers)
    |> Enum.each(fn follower -> Proj4.Node.send(follower, tweet) end)
  end

  @impl GenServer
  def handle_call({:query_tweets, query}) do
    # Search all our tweets. See if the query is contained in the mentions, hashtags, or text of a tweet
    Map.get(state, :tweets)
    |> Enum.reduce(fn tweet, acc -> (if is_matching_tweet(tweet, query) do acc | [tweet] else acc end) end)
  end

  @impl GenServer
  def handle_cast({:publish_tweet, tweet}) do
    # Publish tweet to all followers
    IO.puts "Publishing new tweet to followers."
    Map.get(state, :followers)
    |> Enum.each(fn follower -> Proj4.Node.send(follower, tweet) end)

    # Store tweet in our tweets
    tweets = Map.get(state, :tweets) | tweet
    {:ok, {Map.put(state, :tweets, tweets)}}
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
    query_matches_text = Map.get(tweet, :text) =~ query

    # Return result
    query_matches_mention or query_matches_hashtag or query_matches_text
  end

end
