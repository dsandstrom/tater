defmodule Tater.Feature do
  @moduledoc "Theme feature that will be annotated"

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
    |> auto_map
    |> validate_required([:name, :mapping, :annotation])
    |> validate_format(:mapping, ~r/\A[\w-]+\z/)
    |> validate_length(:mapping, max: 20)
    |> unique_constraint(:name)
    |> unique_constraint(:mapping)
  end

  # when mapping is being changed
  defp auto_map(%Ecto.Changeset{changes: %{name: _, mapping: _}} = changeset) do
    changeset
  end

  # when no mapping
  defp auto_map(%Ecto.Changeset{changes: %{name: name}} = changeset) do
    changeset |> put_change(:mapping, first_available_mapping(name))
  end

  defp auto_map(changeset) do
    changeset
  end

  defp mapping_option(name) do
    name
    |> String.trim
    |> String.downcase
    |> String.replace(~r/\s+/, "-")
  end

  defp mapping_option(name, index) do
    "#{mapping_option(name)}-#{index + 1}"
  end

  defp first_available_mapping(name) do
    # TODO: loop through test mappings instead of just using index
    mapping = mapping_option(name)
    query = from f in Tater.Feature, where: f.mapping == ^mapping
    case Tater.Repo.all(query) do
      [] -> mapping
      matches -> mapping_option(mapping, length(matches))
    end
  end
end
