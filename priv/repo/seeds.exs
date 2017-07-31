defmodule Tater.DatabaseSeeder do
  alias Tater.Repo
  alias Tater.Feature

  def insert_features(0), do: {:ok}
  def insert_features(count \\ 20) do
    insert_feature()
    insert_features(count - 1)
  end

  def insert_feature(name \\ Faker.App.name) do
    params = %{name: name, annotation: Faker.Lorem.paragraph}
    changeset = Feature.changeset(%Feature{}, params)
    Repo.insert changeset
  end
end

Tater.DatabaseSeeder.insert_features()
