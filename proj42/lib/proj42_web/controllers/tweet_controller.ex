defmodule Proj42Web.TweetController do
  use Proj42Web, :controller

  def publish(conn, _params) do
    render(conn, "publish.html")
  end
end
