defmodule TodoApp2.TodoList do
  use TodoApp2.Web, :model

  schema "todo_lists" do
    field :title, :string
    has_many :todo_items, TodoApp2.TodoItem

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title])
    |> validate_required([:title])
    |> cast_assoc(:todo_items, required: true)
  end
end
