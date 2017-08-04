defmodule Tater.V1.FeatureView do
  @moduledoc """
  Helpers for feature API views
  """

  use Tater.Web, :view

  def render("index.json", %{features: features}) do
    %{data: render_many(features, __MODULE__, "feature.json")}
  end

  def render("show.json", %{feature: feature}) do
    %{data: render_one(feature, __MODULE__, "feature.json")}
  end

  def render("feature.json", %{feature: feature}) do
    %{name: feature.name,
      mapping: feature.mapping,
      annotation: feature.annotation}
  end
end
