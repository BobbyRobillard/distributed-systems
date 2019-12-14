defmodule Proj42Web.Router do
  use Proj42Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Proj42Web do
    pipe_through :browser

    get "/", HomeController, :index
    get "/home", HomeController, :index
    get "/login", LoginController, :index
    get "/register", RegisterController, :index
    get "/users", UsersController, :index
    get "/users/:username", UsersController, :index
    get "/follow", FollowController, :index
    get "/unfollow", UnfollowController, :index
    get "/tweet", TweetController, :index
    get "/query", QueryController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", Proj42Web do
  #   pipe_through :api
  # end
end
