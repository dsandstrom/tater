defmodule Tater.V1.FeatureControllerTest do
  use Tater.ConnCase
  alias Tater.Feature

  describe "on index" do
    test "lists all entries on index", %{conn: conn} do
      attrs = %{"name" => "Hero", "mapping" => "hero", "annotation" => "Lorem"}
      Repo.insert! %Feature{name: "Hero", mapping: "hero", annotation: "Lorem"}

      conn = get conn, v1_feature_path(conn, :index)

      assert json_response(conn, 200) == %{"data" => [attrs]}
    end

    test "sets access control allow origin header", %{conn: conn} do
      Repo.insert! %Feature{name: "Hero", mapping: "hero", annotation: "Lorem"}

      conn = get conn, v1_feature_path(conn, :index)

      header = List.keyfind(conn.resp_headers, "access-control-allow-origin", 0)
      assert header == {"access-control-allow-origin", "*"}
    end
  end

  describe "on show" do
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

    test "sets access control allow origin header", %{conn: conn} do
      feature = Repo.insert!(%Feature{name: "Hero", mapping: "hero",
                                      annotation: "Lorem"})

      conn = get conn, v1_feature_path(conn, :show, feature.mapping)

      header = List.keyfind(conn.resp_headers, "access-control-allow-origin", 0)
      assert header == {"access-control-allow-origin", "*"}
    end
  end
end
