defmodule Proj42Web.RegisterController do
  use Proj42Web, :controller

  def index(conn, params) do
    if !Enum.empty?(params) do
      {:ok} = Proj42.Impl.Api.register(params["username"], params["password"])
      redirect(conn, to: "/")
    else
      render(conn, "index.html")
    end
  end

end
