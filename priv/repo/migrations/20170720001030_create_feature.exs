defmodule Tater.Repo.Migrations.CreateFeature do
  use Ecto.Migration

  def change do
    create table(:features) do
      add :name, :string
      add :mapping, :string
      add :annotation, :text

      timestamps()
    end

  end
end
