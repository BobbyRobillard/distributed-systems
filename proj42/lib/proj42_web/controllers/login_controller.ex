defmodule Proj42Web.LoginController do
  use Proj42Web, :controller

  def login(conn, _params) do
    render(conn, "login.html")
  end

end
