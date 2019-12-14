defmodule Proj42Web.HomeController do
  use Proj42Web, :controller

  def index(conn, params) do
    if Map.has_key?(params, "simulate") do
      num_user = 200
      num_msg = 1000
      Enum.each(1..num_user, fn id ->
        Proj42.Impl.Api.register(id, "password")
      end)
      Enum.each(1..5 * num_user, fn id ->
        Proj42.Impl.Api.follow(ceil(id / 2), :rand.uniform(num_user))
      end)
      user = Agent.get(:active_user, fn u -> u end)
      if user != nil do
        Enum.each(1..div(num_user, 10), fn id ->
          Proj42.Impl.Api.follow(user, id * 10)
        end)
      end
      Enum.each(1..num_msg, fn _ ->
        length = :rand.uniform(64)
        Proj42.Impl.Api.tweet(:rand.uniform(num_user), :crypto.strong_rand_bytes(length) |> Base.url_encode64 |> binary_part(0, length))
      end)
    end
    tweets = Agent.get(:active_user, fn u ->
      if u == nil do
        []
      else
        Proj42.Impl.Api.feed(u) |> elem(1)
      end
    end)
    IO.inspect tweets
    conn
      |> assign(:tweets, tweets)
      |> render("index.html")
  end
end
