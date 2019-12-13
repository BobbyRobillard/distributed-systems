defmodule Proj42Web.TweetController do
  use Proj42Web, :controller

  def publish(conn, _params) do
    changeset = User.changeset(%User{})
    render conn, "publish.html", changeset: changeset
  end

  def new(conn, _params) do

  end
end
