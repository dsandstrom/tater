defmodule Tater.Repo.Migrations.AddUniqueIndexToNameAndMappingForFeatures do
  use Ecto.Migration

  def change do
    create unique_index(:features, [:name])
    create unique_index(:features, [:mapping])
  end
end
