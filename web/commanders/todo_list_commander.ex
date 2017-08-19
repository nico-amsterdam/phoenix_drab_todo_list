defmodule TodoApp2.TodoListCommander do
  use Drab.Commander
  
  alias TodoApp2.TodoList
  alias TodoApp2.TodoItem
  alias TodoApp2.Repo
  
  @doc "New task button adds new empty task"
  def new_task_action(socket, sender) do
    {:ok, new_changeset, new_task_no} = new_task(sender.params)

    # update screen
    poke(socket, changeset: new_changeset)

    # set focus on input field of added task
    elemId = "todo_list_todo_items_" <> to_string(new_task_no - 1) <> "_body"
    js = "document.getElementById('" <> elemId <> "').focus();" 
    exec_js(socket, js)
  end

  @doc "Ok button stores todo lists and navigates to main page"
  def ok_action(socket, %{:params => params}) do
    if params["_method"] == "put" do
      update(socket, params)
    else
      create(socket, params)
    end
  end

  # update existing todo list, navigate to main page if no errors
  defp update(socket, %{"id" => id_of_todo_list, "todo_list" => todo_list_params}) do
    todo_list = load_todo_list_with_items(id_of_todo_list)
    changeset = TodoList.changeset(todo_list, todo_list_params)

    case Repo.update(changeset) do
      {:ok, _todo_list} ->
        exec_js socket, "window.location.href = '/todo_lists';"
      {:error, changeset} ->
        poke(socket, changeset: changeset)
    end
  end 

  # create new todo list, navigate to main page if no errors
  defp create(socket, %{"todo_list" => todo_list_params}) do
    changeset = TodoList.changeset(%TodoList{}, todo_list_params)

    case Repo.insert(changeset) do
      {:ok, _todo_list} ->
        exec_js socket, "window.location.href = '/todo_lists';"
      {:error, changeset} ->
        poke(socket, changeset: changeset)
    end
  end

  # New task, update existing todo list, in memory only, do not store yet
  defp new_task(%{"id" => id_of_todo_list, "todo_list" => todo_list_params}) when id_of_todo_list != "/" do
    todo_list = load_todo_list_with_items(id_of_todo_list)
    new_todo_items = new_todo_items!(todo_list_params)
    new_todo_list_params = Map.put(todo_list_params, "todo_items", new_todo_items)
    new_changeset = TodoList.changeset(todo_list, new_todo_list_params)
    {:ok, new_changeset, Map.size(new_todo_items)}
  end

  # New task, todo list is new and not stored yet
  defp new_task(%{"todo_list" => todo_list_params}) do
    new_todo_items = new_todo_items!(todo_list_params)
    new_todo_list_params = Map.put(todo_list_params, "todo_items", new_todo_items)
    new_changeset = TodoList.changeset(%TodoList{}, new_todo_list_params)
    {:ok, new_changeset, Map.size(new_todo_items)}
  end
  
  # load todo list with items
  defp load_todo_list_with_items(id) do
    Repo.get!(TodoList, id) |> Repo.preload(:todo_items)
  end

  # return todo_items with added new empty item
  defp new_todo_items!(todo_list_params) do
    todo_items = Map.get(todo_list_params, "todo_items") || %{}
    # determine task number:
    next_index = Map.size(todo_items)
    Map.put(todo_items, to_string(next_index), %{"body" => nil})
  end

end
