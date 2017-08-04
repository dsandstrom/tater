defmodule Tater.Router do
  @moduledoc """
    Routes
  """
  use Tater.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Tater do
    pipe_through :browser # Use the default browser stack

    get "/", FeatureController, :index
    resources "/features", FeatureController
  end

  scope "/api", Tater do
    pipe_through :api

    scope "/v1", V1, as: :v1 do
      resources "/features", FeatureController, only: [:index, :show]
    end
  end
end
