defmodule PraterWeb.Router do
  use PraterWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug PraterWeb.Plugs.SetCurrentUser
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", PraterWeb do
    pipe_through :browser

    get "/", RoomController, :index
    get "/rooms/new", RoomController, :new
    post "/rooms", RoomController, :create
   # get "/rooms", RoomController, :create
    get "/rooms/:id", RoomController, :show
    get "rooms/:id/edit",RoomController, :edit
    put "/rooms/:id", RoomController, :update
    delete "rooms/:id", RoomController, :delete

    resources "/sessions", SessionController, only: [:new, :create]
    resources "/registrations", RegistrationController, only: [:new, :create]
    delete "/sign_out", SessionController, :delete
    #get "/registration", RegistrationController, :show


  end

  # Other scopes may use custom stacks.
  # scope "/api", PraterWeb do
  #   pipe_through :api
  # end
end
