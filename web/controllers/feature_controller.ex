defmodule Tater.FeatureController do
  @moduledoc """
  Feature controller
  """

  use Tater.Web, :controller

  alias Tater.Feature

  def index(conn, _params) do
    # TODO: add pagination
    query = from f in Feature, order_by: [desc: f.updated_at]
    features = Repo.all(query)
    render(conn, "index.html", features: features)
  end

  def new(conn, _params) do
    changeset = Feature.changeset(%Feature{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"feature" => feature_params}) do
    changeset = Feature.changeset(%Feature{}, feature_params)

    case Repo.insert(changeset) do
      {:ok, _feature} ->
        conn
        |> put_flash(:info, "Feature created successfully.")
        |> redirect(to: feature_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    feature = Repo.get!(Feature, id)
    render(conn, "show.html", feature: feature)
  end

  def edit(conn, %{"id" => id}) do
    feature = Repo.get!(Feature, id)
    changeset = Feature.changeset(feature)
    render(conn, "edit.html", feature: feature, changeset: changeset)
  end

  def update(conn, %{"id" => id, "feature" => feature_params}) do
    feature = Repo.get!(Feature, id)
    changeset = Feature.changeset(feature, feature_params)

    case Repo.update(changeset) do
      {:ok, feature} ->
        conn
        |> put_flash(:info, "Feature updated successfully.")
        |> redirect(to: feature_path(conn, :show, feature))
      {:error, changeset} ->
        render(conn, "edit.html", feature: feature, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    feature = Repo.get!(Feature, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(feature)

    conn
    |> put_flash(:info, "Feature deleted successfully.")
    |> redirect(to: feature_path(conn, :index))
  end
end
