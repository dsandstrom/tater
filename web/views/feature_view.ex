defmodule Tater.FeatureView do
  @moduledoc """
  Helpers for feature views
  """

  use Tater.Web, :view
  import Scrivener.HTML

  def render_features(_f = [], _a), do: render_none()
  def render_features(_f = %Scrivener.Page{entries: []}, _a), do: render_none()
  def render_features(features, conn) do
    content_tag :div, id: "features", class: "features" do
      for feature <- features do
        render "_feature.html", conn: conn, feature: feature
      end
    end
  end

  defp render_none, do: content_tag(:p, "None found")

  def pagination_info(page, type) do
    total_entries = page.total_entries

    first_index = find_first_index(page)
    if first_index <= total_entries do
      content_tag :p, class: "pagination-info" do
        pagination_info_content(page, type)
      end
    end
  end

  defp pagination_info_content(page, type) do
    page_size = page.page_size
    total_entries = page.total_entries
    first_index = find_first_index(page)
    last_index = find_last_index(page)

    if page_size >= total_entries do
      "Displaying all #{type}"
    else
      start = "Displaying "
      indexes =
        if page_size > 1 and first_index != last_index do
          "#{first_index} - #{last_index}"
        else
          first_index
        end

      indexes = content_tag :strong, indexes
      total_entries = content_tag(:strong, total_entries)

      [start, type, " ", indexes, " of ", total_entries, " in total"]
    end
  end

  defp find_first_index(page) do
    (page.page_number - 1) * page.page_size + 1
  end

  defp find_last_index(page) do
    page_number = page.page_number
    page_size = page.page_size
    total_entries = page.total_entries

    index = if page_size > 1, do: page_number * page_size
    cond do
      index > total_entries -> total_entries
      true -> index
    end
  end
end
