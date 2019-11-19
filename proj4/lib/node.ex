defmodule Proj4.Node do
  use GenServer

  defp via_tuple(username), do: {:via, Proj4.Registry, {:node, username}}

  defp gen_cast(username, argument), do: GenServer.cast(via_tuple(username), argument)

  defp gen_call(username, argument), do: GenServer.call(via_tuple(username), argument)

  # ----------------------------------------------------------------------------
  # Public API
  # ----------------------------------------------------------------------------

  def start_link(username), do: GenServer.start_link(__MODULE__, [username], name: via_tuple(username))

  def publish_tweet(username, tweet), do: gen_cast(username, {:publish_tweet, tweet})

  def receive_tweet(username, tweet), do: gen_cast(username, {:receive_tweet, tweet})

  def add_follower(username, follower), do: gen_cast(username, {:add_follower, follower})

  def remove_follower(username, follower), do: gen_cast(username, {:remove_follower, follower})

  def get_tweets(username), do: gen_call(username, :get_tweets)

  def get_followers(username), do: gen_call(username, :get_followers)

  def query_tweets(username, query), do: gen_call(username, {:query_tweets, query})

  # ----------------------------------------------------------------------------
  # Internal API
  # ----------------------------------------------------------------------------

  @impl GenServer
  def init(username) do
    {:ok, %{
        username: username,
        tweets: :ets.new(:tweets, [:set, :private]),
        followers: :ets.new(:followers, [:set, :private])
    }}
  end

  @impl GenServer
  def handle_cast({:publish_tweet, tweet}, state) do
    # Send tweet to all our followers
    # TODO: Store tweet in our tweets only if it's not a re-tweet
    :ets.insert(state[:tweets], {tweet})
    :ets.tab2list(state[:followers])
      |> Enum.each(fn f -> receive_tweet(f, tweet) end)
    {:noreply, state}
  end

  @impl GenServer
  def handle_cast({:receive_tweet, tweet}, state) do
    IO.puts "#{state[:username]} received tweet: #{tweet[:content]}"
    {:noreply, state}
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
  def handle_call(:get_tweets, _from, state), do: {:reply, :ets.tab2list(state[:tweets]), state}

  @impl GenServer
  def handle_call(:get_followers, _from, state), do: {:reply, :ets.tab2list(state[:followers]), state}

  @impl GenServer
  def handle_call({:query_tweets, query}, _from, state) do
    query = String.downcase(query)
    # Get tweets from ETS query for anything that matches
    matching_tweets = :ets.tab2list(state[:tweets])
      |> Enum.map(fn entry -> elem(entry, 0) end) #Extract tweet from tuple entry
      |> Enum.filter(fn tweet ->
        Enum.any?(tweet[:mentions], fn m -> String.downcase(m) == query end) #same as mention
        or Enum.any?(tweet[:hashtags], fn h -> String.downcase(h) == query end) #same as tag
        or String.downcase(tweet[:content]) =~ query #contains query
      end)
    {:reply, matching_tweets, state}
  end

end
