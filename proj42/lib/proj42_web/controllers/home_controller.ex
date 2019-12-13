defmodule Proj42Web.HomeController do
  use Proj42Web, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
