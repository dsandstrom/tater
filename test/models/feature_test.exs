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

    test "changeset is invalid if name is used already" do
      %Feature{}
      |> Feature.changeset(@valid_attrs)
      |> Tater.Repo.insert!
      feature =
        %Feature{}
        |> Feature.changeset(@valid_attrs)

      {:error, changeset} = Repo.insert(feature)
      refute changeset.valid?
      assert changeset.errors[:name] == {"has already been taken", []}
    end

    test "changeset is invalid if mapping is used already" do
      attrs = @valid_attrs |> Map.put(:mapping, "same-mapping")
      %Feature{}
      |> Feature.changeset(attrs)
      |> Tater.Repo.insert!
      attrs = attrs |> Map.put(:name, "Different Name")
      feature =
        %Feature{}
        |> Feature.changeset(attrs)

      assert {:error, changeset} = Repo.insert(feature)
      refute changeset.valid?
      assert changeset.errors[:mapping] == {"has already been taken", []}
    end
  end

  describe "#auto_map" do
    test "generates one when blank" do
      changeset = Feature.changeset(%Feature{}, %{name: "Hero", mapping: ""})
      assert fetch_field(changeset, :mapping) == {:changes, "hero"}
    end

    test "generates one when not changing mapping" do
      attrs = %{name: "Hero", annotation: "some content"}
      changeset = Feature.changeset(%Feature{}, attrs)
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
      attrs = %{name: "Hero", mapping: "custom"}
      changeset = Feature.changeset(%Feature{}, attrs)
      assert fetch_field(changeset, :mapping) == {:changes, "custom"}
    end

    test "when default auto mapping is already taken, appends '-1'" do
      Repo.insert! %Feature{mapping: "hero"}
      changeset = Feature.changeset(%Feature{}, %{name: "Hero"})
      assert fetch_field(changeset, :mapping) == {:changes, "hero-1"}
    end

    test "when default and -1 auto mapping is already taken, appends '-2'" do
      Repo.insert! %Feature{mapping: "hero"}
      Repo.insert! %Feature{mapping: "hero-1"}
      changeset = Feature.changeset(%Feature{}, %{name: "Hero"})
      assert fetch_field(changeset, :mapping) == {:changes, "hero-2"}
    end

    test "when editing, doesn't change mapping when name blank" do
      feature = Repo.insert! %Feature{name: "Hero", mapping: "hero"}
      attrs = %{name: "", mapping: "hero"}
      changeset = Feature.changeset(feature, attrs)
      assert fetch_field(changeset, :mapping) == {:data, "hero"}
    end

    test "when editing, auto maps when mapping is blank" do
      feature = Repo.insert! %Feature{name: "Hero", mapping: "hero"}
      attrs = %{name: "New Name", mapping: ""}
      changeset = Feature.changeset(feature, attrs)
      assert fetch_field(changeset, :mapping) == {:changes, "new-name"}
    end

    test "when editing, auto maps when resetting mapping" do
      feature = Repo.insert! %Feature{name: "Hero", mapping: "wrong"}
      attrs = %{mapping: nil}
      changeset = Feature.changeset(feature, attrs)
      assert fetch_field(changeset, :mapping) == {:changes, "hero"}
    end

    test "when editing, doesn't allow removing mapping" do
      feature = Repo.insert! %Feature{name: "Hero", mapping: "hero"}
      attrs = %{mapping: nil}
      changeset = Feature.changeset(feature, attrs)
      assert fetch_field(changeset, :mapping) == {:data, "hero"}
    end

    test "when editing, doesn't change mapping when changing name" do
      feature = Repo.insert! %Feature{name: "Hero", mapping: "hero"}
      attrs = %{name: "New Name"}
      changeset = Feature.changeset(feature, attrs)
      assert fetch_field(changeset, :mapping) == {:data, "hero"}
    end

    test "when editing feature without a mapping, auto maps" do
      feature = Repo.insert! %Feature{name: "Hero"}
      attrs = %{}
      changeset = Feature.changeset(feature, attrs)
      assert fetch_field(changeset, :mapping) == {:changes, "hero"}
    end

    test "doesn't break when name is nil" do
      changeset = Feature.changeset(%Feature{}, %{name: nil})
      assert fetch_field(changeset, :mapping) == {:data, nil}
    end

    test "generates one shorter than 20 characters" do
      name = "Really Long Name That Should Get Truncated"
      mapping = "really-long-name-tha"
      changeset = Feature.changeset(%Feature{}, %{name: name})
      assert fetch_field(changeset, :mapping) == {:changes, mapping}
    end
  end

  describe ".search_for" do
    test "returns features with matching name" do
      feature = Repo.insert! %Feature{name: "alpha"}
      Repo.insert! %Feature{name: "beta"}
      features = Feature |> Feature.search_for("alpha") |> Repo.all
      assert features == [feature]
    end

    test "returns features with similar name" do
      feature = Repo.insert! %Feature{name: "alpha"}
      Repo.insert! %Feature{name: "beta"}
      features = Feature |> Feature.search_for("alp") |> Repo.all
      assert features == [feature]
    end

    test "returns features with case insensitive name" do
      feature = Repo.insert! %Feature{name: "AlPhA"}
      Repo.insert! %Feature{name: "beta"}
      features = Feature |> Feature.search_for("alp") |> Repo.all
      assert features == [feature]
    end

    test "returns all features when no search term" do
      feature_0 = Repo.insert! %Feature{name: "alpha"}
      feature_1 = Repo.insert! %Feature{name: "beta"}
      features = Feature |> Feature.search_for() |> Repo.all
      assert features == [feature_0, feature_1]
    end

    test "returns all features when blank search term" do
      feature_0 = Repo.insert! %Feature{name: "alpha"}
      feature_1 = Repo.insert! %Feature{name: "beta"}
      features = Feature |> Feature.search_for("") |> Repo.all
      assert features == [feature_0, feature_1]
    end
  end
end
