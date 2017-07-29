defmodule Tater.Repo do
  @moduledoc """
  Repo
  """

  use Ecto.Repo, otp_app: :tater
  use Scrivener, page_size: 10
end
