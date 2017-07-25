defmodule TodoApp2.PageController do
  use TodoApp2.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
