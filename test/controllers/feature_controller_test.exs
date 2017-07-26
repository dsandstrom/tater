defmodule Tater.FeatureControllerTest do
  use Tater.ConnCase

  alias Tater.Feature
  @valid_attrs %{annotation: "some content", mapping: "some-content",
                 name: "some content"}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, feature_path(conn, :index)
    assert html_response(conn, 200) =~ "Features"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, feature_path(conn, :new)
    assert html_response(conn, 200) =~ "New Feature"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, feature_path(conn, :create), feature: @valid_attrs
    assert redirected_to(conn) == feature_path(conn, :index)
    assert Repo.get_by(Feature, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid",
       %{conn: conn} do
    conn = post conn, feature_path(conn, :create), feature: @invalid_attrs
    assert html_response(conn, 200) =~ "New Feature"
  end

  test "shows chosen resource", %{conn: conn} do
    feature = Repo.insert! %Feature{}
    conn = get conn, feature_path(conn, :show, feature)
    assert html_response(conn, 200) =~ "#{feature.name}"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, feature_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    feature = Repo.insert! %Feature{}
    conn = get conn, feature_path(conn, :edit, feature)
    assert html_response(conn, 200) =~ "Edit #{feature.name} Feature"
  end

  test "updates chosen resource and redirects when data is valid",
       %{conn: conn} do
    feature = Repo.insert! %Feature{}
    conn = put conn, feature_path(conn, :update, feature), feature: @valid_attrs
    assert redirected_to(conn) == feature_path(conn, :show, feature)
    assert Repo.get_by(Feature, @valid_attrs)
  end

  test "doesn't update chosen resource and renders errors when data is invalid",
       %{conn: conn} do
    feature = Repo.insert! %Feature{}
    conn = put conn, feature_path(conn, :update, feature),
               feature: @invalid_attrs

    assert html_response(conn, 200) =~ "Edit #{feature.name} Feature"
  end

  test "deletes chosen resource", %{conn: conn} do
    feature = Repo.insert! %Feature{}
    conn = delete conn, feature_path(conn, :delete, feature)
    assert redirected_to(conn) == feature_path(conn, :index)
    refute Repo.get(Feature, feature.id)
  end
end
