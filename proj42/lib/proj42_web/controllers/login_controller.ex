defmodule Proj42Web.LoginController do
  use Proj42Web, :controller

  def index(conn, params) do
    if !Enum.empty?(params) do
      {:ok} = Proj42.Impl.Api.login(params["username"], params["password"])
      Agent.update(:active_user, fn _ -> params["username"] end)
      redirect(conn, to: "/users/#{params["username"]}")
    else
      render(conn, "index.html")
    end
  end

end
