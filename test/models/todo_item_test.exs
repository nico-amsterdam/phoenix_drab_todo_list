defmodule TodoApp2.TodoItemTest do
  use TodoApp2.ModelCase

  alias TodoApp2.TodoItem

  @valid_attrs %{body: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = TodoItem.changeset(%TodoItem{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = TodoItem.changeset(%TodoItem{}, @invalid_attrs)
    refute changeset.valid?
  end
end
