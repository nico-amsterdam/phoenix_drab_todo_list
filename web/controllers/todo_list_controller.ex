defmodule TodoApp2.TodoListController do
  use TodoApp2.Web, :controller

  alias TodoApp2.TodoList

  def action(conn, opts) do
    if conn.params["cmd"] == "new_task" do
      new_task(conn, conn.params)
    else
      super(conn, opts)
    end
  end

  def new_task(conn, %{"id" => id, "todo_list" => todo_list_params}) do
    todo_list = load_todo_list_with_items(id)
    new_todo_items = new_todo_items!(todo_list_params)
    new_todo_list_params = Map.put(todo_list_params, "todo_items", new_todo_items)
    changeset = TodoList.changeset(todo_list, new_todo_list_params)
    render(conn, "edit.html", todo_list: todo_list, changeset: changeset, new_task: Map.size(new_todo_items) - 1)
  end

  def new_task(conn, %{"todo_list" => todo_list_params}) do
    new_todo_items = new_todo_items!(todo_list_params)
    new_todo_list_params = Map.put(todo_list_params, "todo_items", new_todo_items)
    changeset = TodoList.changeset(%TodoList{}, new_todo_list_params)
    render(conn, "new.html", changeset: changeset, new_task: Map.size(new_todo_items) - 1)
  end

  defp load_todo_list_with_items(id) do
    Repo.get!(TodoList, id) |> Repo.preload(:todo_items)
  end

  defp new_todo_items!(todo_list_params) do
    todo_items = Map.get(todo_list_params, "todo_items") || %{}
    next_index = Map.size(todo_items)
    Map.put(todo_items, to_string(next_index), %{"body" => nil})
  end

  def index(conn, _params) do
    todo_lists = Repo.all(TodoList)
    render(conn, "index.html", todo_lists: todo_lists)
  end

  def new(conn, _params) do
    changeset = TodoList.changeset(%TodoList{todo_items: [%TodoApp2.TodoItem{}]})

    render(conn, "new.html", changeset: changeset, new_task: -1)
  end

  def create(conn, %{"todo_list" => todo_list_params}) do
    changeset = TodoList.changeset(%TodoList{}, todo_list_params)

    case Repo.insert(changeset) do
      {:ok, _todo_list} ->
        conn
        |> put_flash(:info, "Todo list created successfully.")
        |> redirect(to: todo_list_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    todo_list = Repo.get!(TodoList, id)
    render(conn, "show.html", todo_list: todo_list)
  end

  def edit(conn, %{"id" => id}) do
    todo_list = load_todo_list_with_items(id)
    changeset = TodoList.changeset(todo_list)
    render(conn, "edit.html", todo_list: todo_list, changeset: changeset, new_task: -1)
  end

  def update(conn, %{"id" => id, "todo_list" => todo_list_params}) do
    todo_list = load_todo_list_with_items(id)
    changeset = TodoList.changeset(todo_list, todo_list_params)

    case Repo.update(changeset) do
      {:ok, _todo_list} ->
        conn
        |> put_flash(:info, "Todo list updated successfully.")
        |> redirect(to: todo_list_path(conn, :index))
      {:error, changeset} ->
        render(conn, "edit.html", todo_list: todo_list, changeset: changeset, new_task: -1)
    end
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
