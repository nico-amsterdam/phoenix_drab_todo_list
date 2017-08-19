defmodule TodoApp2.TodoItem do
  use TodoApp2.Web, :model

  @required_fields [:body]
  @optional_fields [:delete_item]

  schema "todo_items" do
    field :body, :string
    belongs_to :todo_list, TodoApp2.TodoList
    field :delete_item, :boolean, virtual: true

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields, [])
#    |> validate_length(:body, min: 3)
    |> mark_for_deletion()
  end

  defp mark_for_deletion(changeset) do
    if get_change(changeset, :delete_item) do
      %{changeset | action: :delete}
    else
      changeset
    end
  end
end
