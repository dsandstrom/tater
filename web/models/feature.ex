defmodule Tater.Feature do
  @moduledoc """
  Theme feature that will be annotated"
  """
  # TODO: add seed data

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

  # TODO: don't change mapping after changing name
  # no mapping
  defp auto_map(%Ecto.Changeset{changes: %{name: name, mapping: nil}} = changeset),
    do: changeset |> put_change(:mapping, first_available_mapping(name))
  # mapping is being manually set
  defp auto_map(%Ecto.Changeset{changes: %{name: _, mapping: _}} = changeset),
    do: changeset
  # trying to change name to nil
  defp auto_map(%Ecto.Changeset{changes: %{name: nil}} = changeset),
    do: changeset
  # trying to set mapping to nil
  defp auto_map(%Ecto.Changeset{changes: %{mapping: nil}, data: %{name: name, mapping: original_mapping}} = changeset) do
    if mapping_option(name) == original_mapping do
      # keep original
      changeset |> delete_change(:mapping)
    else
      changeset |> put_change(:mapping, first_available_mapping(name))
    end
  end
  # no mapping
  defp auto_map(%Ecto.Changeset{changes: %{name: name}} = changeset),
    do: changeset |> put_change(:mapping, first_available_mapping(name))
  # no changes
  defp auto_map(changeset),
    do: changeset

  defp first_available_mapping(name) do
    mapping = mapping_option(name)
    if mapping_is_available(mapping) do
      mapping
    else
      first_available_mapping(name, 1)
    end
  end

  defp first_available_mapping(name, index) do
    mapping = mapping_option(name, index)
    if mapping_is_available(mapping) do
      mapping
    else
      first_available_mapping(name, index + 1)
    end
  end

  defp mapping_option(name, index), do: "#{mapping_option(name)}-#{index}"
  defp mapping_option(name) do
    name
    |> String.trim
    |> String.downcase
    |> String.replace(~r/\s+/, "-")
  end

  defp mapping_is_available(mapping) do
    query = from f in Tater.Feature, where: f.mapping == ^mapping
    length(Tater.Repo.all(query)) == 0
  end
end
