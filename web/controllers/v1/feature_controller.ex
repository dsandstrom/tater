defmodule Tater.V1.FeatureController do
  @moduledoc """
  Feature controller
  """

  use Tater.Web, :controller

  alias Tater.Feature

  def index(conn, _) do
    features = Repo.all(Feature)
    render conn, "index.json", features: features
  end

  def show(conn, %{"mapping" => mapping}) do
    feature = Repo.get_by(Feature, mapping: mapping)
    conn
    |> put_current_status(feature)
    |> render("show.json", feature: feature)
  end

  defp put_current_status(conn, nil), do: put_status(conn, 404)
  defp put_current_status(conn, _), do: conn
end
