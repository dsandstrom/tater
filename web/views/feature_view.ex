defmodule Tater.FeatureView do
  @moduledoc """
  Helpers for feature views
  """

  use Tater.Web, :view

  def render_features(_f = [], _a), do: content_tag(:p, "None yet")
  # TODO: pass `feature` variable to partial
  # get compilation error saying undefined feature
  def render_features(features, assigns) do
    content_tag :div, id: "features", class: "features" do
      for feature <- features do
        assigns = Map.put_new(assigns, :feature, feature)
        render "_feature.html", assigns
      end
    end
  end
end
