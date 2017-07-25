defmodule TodoApp2.TodoListTest do
  use TodoApp2.ModelCase

  alias TodoApp2.TodoList

  @valid_attrs %{title: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = TodoList.changeset(%TodoList{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = TodoList.changeset(%TodoList{}, @invalid_attrs)
    refute changeset.valid?
  end
end
