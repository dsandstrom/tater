defmodule Tater.Feature do
  use Tater.Web, :model

  schema "features" do
    field :name, :string
    field :mapping, :string
    field :annotation, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :mapping, :annotation])
    |> validate_required([:name, :mapping, :annotation])
  end
end
