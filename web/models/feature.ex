defmodule Tater.Feature do
  @moduledoc """
  Theme feature that will be annotated"
  """
  # TODO: add api

  use Tater.Web, :model
  use Phoenix.HTML.SimplifiedHelpers

  alias Tater.Repo
  alias Tater.Feature

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

  # no mapping
  defp auto_map(%Ecto.Changeset{changes: %{name: name, mapping: nil}} = changeset) when name !== nil,
    do: changeset |> put_change(:mapping, first_available_mapping(name))
  # mapping is being manually set
  defp auto_map(%Ecto.Changeset{changes: %{name: _, mapping: _}} = changeset),
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
  # update a feature with no mapping
  defp auto_map(%Ecto.Changeset{changes: %{name: name}, data: %{mapping: nil}} = changeset),
    do: changeset |> put_change(:mapping, first_available_mapping(name))
  # update a feature with no mapping
  defp auto_map(%Ecto.Changeset{changes: %{}, data: %{name: name, mapping: nil}} = changeset) when name != nil,
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
  defp mapping_option(name) when is_bitstring(name) do
    name
    |> String.trim
    |> String.downcase
    |> String.replace(~r/\s+/, "-")
    |> truncate(length: 20, omission: "")
  end

  defp mapping_is_available(mapping) do
    query = from f in Feature, where: f.mapping == ^mapping
    length(Repo.all(query)) == 0
  end

  def search_for(query), do: query
  def search_for(query, _ = ""), do: query
  def search_for(query, term) do
    from f in query, where: ilike(f.name, ^"%#{term}%")
  end
end
