defmodule Tater.LayoutView do
  @moduledoc """
  Conveniences for layout views.
  """

  use Tater.Web, :view

  def show_flash(conn, type) do
    if get_flash(conn, type) != nil do
      flash_message(type, get_flash(conn, type))
    end
  end

  defp flash_message(type, message) do
    content_tag :div, class: "alert alert-#{type}" do
      content_tag :div, class: "page" do
        content_tag(:p, message)
      end
    end
  end
end
