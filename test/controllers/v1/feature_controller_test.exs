defmodule Tater.V1.FeatureControllerTest do
  use Tater.ConnCase
  alias Tater.Feature

  describe "for JSON requests" do
    test "lists all entries on index", %{conn: conn} do
      attrs = %{"name" => "Hero", "mapping" => "hero", "annotation" => "Lorem"}
      Repo.insert! %Feature{name: "Hero", mapping: "hero", annotation: "Lorem"}

      conn = get conn, v1_feature_path(conn, :index)

      assert json_response(conn, 200) == %{"data" => [attrs]}
    end

    test "shows chosen resource", %{conn: conn} do
      attrs = %{"name" => "Hero", "mapping" => "hero", "annotation" => "Lorem"}
      feature = Repo.insert!(%Feature{name: "Hero", mapping: "hero",
                                      annotation: "Lorem"})

      conn = get conn, v1_feature_path(conn, :show, feature.mapping)

      assert json_response(conn, 200) == %{"data" => attrs}
    end

    test "returns 404 when resource not found", %{conn: conn} do
      Repo.insert!(%Feature{name: "Hero", mapping: "hero", annotation: "Lorem"})

      conn = get conn, v1_feature_path(conn, :show, "nope")

      assert json_response(conn, 404) == %{"data" => nil}
    end
  end
end
