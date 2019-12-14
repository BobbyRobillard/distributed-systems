defmodule Proj42Web.UsersController do
  use Proj42Web, :controller

  def index(conn, params) do
    if !Enum.empty?(params) do
      {:ok, following} = Proj42.Impl.Api.following(params["username"])
      {:ok, followers} = Proj42.Impl.Api.followers(params["username"])
      conn
        |> assign(:following, following)
        |> assign(:followers, followers)
        |> render("user.html")
    else
      {:ok, users} = Proj42.Impl.Api.users()
      conn
        |> assign(:users, users)
        |> render("users.html")
    end
  end

end
