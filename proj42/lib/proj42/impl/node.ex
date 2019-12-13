defmodule Proj42.Impl.Node do
  use GenServer

  defp via_tuple(username), do: {:via, Proj42.Impl.Registry, {:node, username}}

  defp gen_cast(username, argument), do: GenServer.cast(via_tuple(username), argument)

  defp gen_call(username, argument), do: GenServer.call(via_tuple(username), argument)

  # ----------------------------------------------------------------------------
  # Public API
  # ----------------------------------------------------------------------------

  def start_link(username), do: GenServer.start_link(__MODULE__, [username], name: via_tuple(username))

  def set_status(username, status), do: gen_cast(username, {:set_status, status})

  def publish_tweet(username, tweet), do: gen_cast(username, {:publish_tweet, tweet})

  def receive_tweet(username, tweet), do: gen_cast(username, {:receive_tweet, tweet})

  def follow_user(username, user) do
    gen_cast(username, {:follow_user, user})
    gen_cast(user, {:add_follower, username})
  end

  def unfollow_user(username, user) do
    gen_cast(username, {:unfollow_user, user})
    gen_cast(user, {:remove_follower, username})
  end

  def get_status(username), do: gen_call(username, :get_status)

  def get_tweets(username), do: gen_call(username, :get_tweets)

  def get_following(username), do: gen_call(username, :get_following)

  def get_followers(username), do: gen_call(username, :get_followers)

  def query_tweets(username, query, neighbors), do: gen_call(username, {:query_tweets, query, neighbors})

  # ----------------------------------------------------------------------------
  # Internal API
  # ----------------------------------------------------------------------------

  @impl GenServer
  def init(username) do
    tweets = :ets.new(:tweets, [:set, :private])
    followers = :ets.new(:followers, [:set, :private])
    following = :ets.new(:following, [:set, :private])
    {:ok, %{
      username: username,
      last_active: 0,
      tweets: tweets,
      followers: followers,
      following: following
    }}
  end

  def handle_cast({:set_status, status}, state) do
    last_active = case status do
       :online -> 0
       :offline -> System.system_time(:second)
    end
    {:noreply, Map.put(state, :last_active, last_active)}
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
    if state[:last_active] == 0 do
      IO.puts "#{state[:username]} received tweet: #{tweet[:content]}"
    else
      IO.puts "#{state[:username]} received tweet: #{tweet[:content]}, but is offline."
    end
    {:noreply, state}
  end

  @impl GenServer
  def handle_cast({:follow_user, user}, state) do
    :ets.insert(state[:following], {user})
    {:noreply, state}
  end

  @impl GenServer
  def handle_cast({:add_follower, user}, state) do
    :ets.insert(state[:followers], {user})
    {:noreply, state}
  end

  @impl GenServer
  def handle_cast({:unfollow_user, user}, state) do
    :ets.delete(state[:following], user)
    {:noreply, state}
  end

  @impl GenServer
  def handle_cast({:remove_follower, user}, state) do
    :ets.delete(state[:followers], user)
    {:noreply, state}
  end

  @impl GenServer
  def handle_call(:get_status, _from, state) do
    status = if state[:last_active] == 0 do :online else :offline end
    {:reply, status, state}
  end

  @impl GenServer
  def handle_call(:get_tweets, _from, state), do: {:reply, ets_list(state[:tweets]), state}

  @impl GenServer
  def handle_call(:get_following, _from, state), do: {:reply, ets_list(state[:following]), state}

  @impl GenServer
  def handle_call(:get_followers, _from, state), do: {:reply, ets_list(state[:followers]), state}

  @impl GenServer
  def handle_call({:query_tweets, query, neighbors}, _from, state) do
    query = String.downcase(query)
    self = elem(handle_call({:query_tweets_impl, query}, nil, state), 1) #query self
    followers = if neighbors do [] else ets_list(state[:following]) |> Enum.flat_map(fn user ->
      gen_call(user, {:query_tweets_impl, query}) #query followers for tweets
    end) end
    {:reply, Enum.concat(self, followers), state}
  end

  @impl GenServer
  def handle_call({:query_tweets_impl, query}, _from, state) do
    results = ets_list(state[:tweets]) |> Enum.filter(fn tweet ->
      Enum.any?(tweet[:mentions], fn m -> String.downcase(m) == query end) #same as mention
      or Enum.any?(tweet[:hashtags], fn h -> String.downcase(h) == query end) #same as tag
      or String.downcase(tweet[:content]) =~ query #contains query
    end)
    {:reply, results, state}
  end

  defp ets_list(table), do: :ets.tab2list(table) |> Enum.map(fn entry -> elem(entry, 0) end)

end
