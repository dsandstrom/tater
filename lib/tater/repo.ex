defmodule Tater.Repo do
  @moduledoc """
  Repo
  """

  use Ecto.Repo, otp_app: :tater
  use Scrivener, page_size: 20
end
