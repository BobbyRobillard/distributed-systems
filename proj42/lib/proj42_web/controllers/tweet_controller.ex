defmodule Proj42Web.TweetController do
  use Proj42Web, :controller

  def index(conn, params) do
    if !Enum.empty?(params) do
      user = Agent.get(:active_user, fn u -> u end)
      {:ok} = Proj42.Impl.Api.tweet(user, params["message"])
      redirect(conn, to: "/users/#{user}")
    else
      render(conn, "index.html")
    end
  end

end
