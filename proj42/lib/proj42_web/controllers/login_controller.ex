defmodule Proj42Web.LoginController do
  use Proj42Web, :controller

  def index(conn, params) do
    if !Enum.empty?(params) do
      {:ok} = Proj42.Impl.Api.login(params["username"], params["password"])
      IO.puts "Successfully logged in"
      redirect(conn, to: "/")
    else
      render(conn, "index.html")
    end
  end

end
