defmodule Tater.PageController do
  use Tater.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
