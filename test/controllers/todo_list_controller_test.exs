defmodule TodoApp2.TodoListControllerTest do
  use TodoApp2.ConnCase

  alias TodoApp2.TodoList
  @valid_attrs %{title: "some content"}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, todo_list_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing todo lists"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, todo_list_path(conn, :new)
    assert html_response(conn, 200) =~ "New todo list"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, todo_list_path(conn, :create), todo_list: @valid_attrs
    assert redirected_to(conn) == todo_list_path(conn, :index)
    assert Repo.get_by(TodoList, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, todo_list_path(conn, :create), todo_list: @invalid_attrs
    assert html_response(conn, 200) =~ "New todo list"
  end

  test "shows chosen resource", %{conn: conn} do
    todo_list = Repo.insert! %TodoList{}
    conn = get conn, todo_list_path(conn, :show, todo_list)
    assert html_response(conn, 200) =~ "Show todo list"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, todo_list_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    todo_list = Repo.insert! %TodoList{}
    conn = get conn, todo_list_path(conn, :edit, todo_list)
    assert html_response(conn, 200) =~ "Edit todo list"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    todo_list = Repo.insert! %TodoList{}
    conn = put conn, todo_list_path(conn, :update, todo_list), todo_list: @valid_attrs
    assert redirected_to(conn) == todo_list_path(conn, :show, todo_list)
    assert Repo.get_by(TodoList, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    todo_list = Repo.insert! %TodoList{}
    conn = put conn, todo_list_path(conn, :update, todo_list), todo_list: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit todo list"
  end

  test "deletes chosen resource", %{conn: conn} do
    todo_list = Repo.insert! %TodoList{}
    conn = delete conn, todo_list_path(conn, :delete, todo_list)
    assert redirected_to(conn) == todo_list_path(conn, :index)
    refute Repo.get(TodoList, todo_list.id)
  end
end
