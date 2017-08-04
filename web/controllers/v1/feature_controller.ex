defmodule Tater.V1.FeatureController do
  @moduledoc """
  Feature controller
  """

  use Tater.Web, :controller

  alias Tater.Feature

  def index(conn, params) do
    features = Repo.all(Feature)
    render conn, "index.json",
      features: features
  end

  def show(conn, %{"id" => id}) do
    # TODO: add mapping index to db
    # TODO: find by mapping
    feature = Repo.get!(Feature, id)
    render(conn, "show.json", feature: feature)
  end
end
