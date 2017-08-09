defmodule Tater.V1.FeatureController do
  @moduledoc """
  Feature controller
  """

  # TODO: respond with 201 not changed when appropiate

  use Tater.Web, :controller

  alias Tater.Feature

  def index(conn, _) do
    conn = Plug.Conn.put_resp_header(conn, "access-control-allow-origin", "*")
    features = Repo.all(Feature)
    render conn, "index.json", features: features
  end

  def show(conn, %{"mapping" => mapping}) do
    conn = Plug.Conn.put_resp_header(conn, "access-control-allow-origin", "*")
    feature = Repo.get_by(Feature, mapping: mapping)
    conn
    |> put_current_status(feature)
    |> render("show.json", feature: feature)
  end

  # return 404 when feature not found
  defp put_current_status(conn, nil), do: put_status(conn, 404)
  defp put_current_status(conn, _), do: conn
end
