defmodule Tater.FeatureTest do
  use Tater.ModelCase

  alias Tater.Feature

  @valid_attrs %{name: "some content", annotation: "some content"}
  @invalid_attrs %{name: ""}

  describe "validations" do
    test "changeset with valid attributes" do
      changeset = Feature.changeset(%Feature{}, @valid_attrs)
      assert changeset.valid?
    end

    test "changeset with invalid attributes" do
      changeset = Feature.changeset(%Feature{}, @invalid_attrs)
      refute changeset.valid?
    end

    test "changeset with mapping with space" do
      attrs = @valid_attrs |> Map.put(:mapping, "not valid")
      changeset = Feature.changeset(%Feature{}, attrs)
      refute changeset.valid?
    end

    test "changeset with mapping longer than 20 characters" do
      attrs = @valid_attrs |> Map.put(:mapping, String.duplicate("a", 21))
      changeset = Feature.changeset(%Feature{}, attrs)
      refute changeset.valid?
    end
  end

  describe "#auto_map" do
    test "generates one when blank" do
      changeset = Feature.changeset(%Feature{}, %{name: "Hero", mapping: ""})
      assert fetch_field(changeset, :mapping) == {:changes, "hero"}
    end

    test "generates one when not changing mapping" do
      changeset = Feature.changeset(%Feature{},
                                    %{name: "Hero", annotation: "some content"})
      assert fetch_field(changeset, :mapping) == {:changes, "hero"}
    end

    test "substitutes spaces for dashes" do
      changeset = Feature.changeset(%Feature{}, %{name: "Supa Hero"})
      assert fetch_field(changeset, :mapping) == {:changes, "supa-hero"}
    end

    test "trims leading and trailing spaces" do
      changeset = Feature.changeset(%Feature{}, %{name: " Supa  Hero  "})
      assert fetch_field(changeset, :mapping) == {:changes, "supa-hero"}
    end

    test "doesn't auto map when getting changed" do
      changeset = Feature.changeset(%Feature{},
                                    %{name: "Hero", mapping: "custom"})
      assert fetch_field(changeset, :mapping) == {:changes, "custom"}
    end

    test "when auto mapping is already taken, appends '-2'" do
      Repo.insert! %Feature{mapping: "hero"}
      changeset = Feature.changeset(%Feature{}, %{name: "Hero"})
      assert fetch_field(changeset, :mapping) == {:changes, "hero-2"}
    end
  end
end
