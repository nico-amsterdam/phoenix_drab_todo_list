defmodule TodoApp2.TodoListController do
  use TodoApp2.Web, :controller
  use Drab.Controller

  alias TodoApp2.TodoList
  alias TodoApp2.TodoItem

  defp load_todo_list_with_items(id) do
    Repo.get!(TodoList, id) |> Repo.preload(:todo_items)
  end

  def index(conn, _params) do
    todo_lists = Repo.all(TodoList)
    render(conn, "index.html", todo_lists: todo_lists, welcome_text: "Listing todo lists")
  end

  def new(conn, _params) do
    changeset = TodoList.changeset(%TodoList{todo_items: [%TodoItem{}]})

    render(conn, "new.html", changeset: changeset)
  end

  def show(conn, %{"id" => id}) do
    todo_list = load_todo_list_with_items(id)
    render(conn, "show.html", todo_list: todo_list)
  end

  def edit(conn, %{"id" => id}) do
    todo_list = load_todo_list_with_items(id)
    changeset = TodoList.changeset(todo_list)
    render(conn, "edit.html", todo_list: todo_list, changeset: changeset)
  end

  def delete(conn, %{"id" => id}) do
    todo_list = Repo.get!(TodoList, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(todo_list)

    conn
    |> put_flash(:info, "Todo list deleted successfully.")
    |> redirect(to: todo_list_path(conn, :index))
  end
end
