defmodule Proj42Web.QueryController do
  use Proj42Web, :controller

  def index(conn, params) do
    if !Enum.empty?(params) do
      user = Agent.get(:active_user, fn u -> u end)
      {:ok, tweets} = Proj42.Impl.Api.query(user, params["query"])
      conn
        |> assign(:query, params["query"])
        |> assign(:tweets, tweets)
        |> render("results.html")
    else
      render(conn, "query.html")
    end
  end

end
