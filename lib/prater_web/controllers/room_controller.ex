defmodule PraterWeb.RoomController do
  use PraterWeb, :controller
  import Plug.Conn
  import Phoenix.Controller

  alias Prater.Conversation.Room
  alias Prater.Conversation
  alias Prater.Repo
  alias Prater.Auth.Authorizer

  plug PraterWeb.Plugs.AuthenticateUser when action not in [:index]
  plug :authorize_user when action in [:edit, :update, :delete]


  def index(conn, _params) do
    rooms = Prater.Conversation.list_rooms()
    render(conn, "index.html", rooms: rooms)
  end

  def new(conn, _params) do
    changeset = Room.changeset(%Room{}, %{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"room" => room_params}) do
    %Room{}
    |> Room.changeset(room_params)
    |> Repo.insert()
    |> case do
      {:ok, _room} ->
        conn
        |> put_flash(:info, "Room created successfully.")
        |> redirect(to: Routes.room_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    room = Conversation.get_room!(id)
    render(conn, "show.html", room: room)
  end

  @spec edit(Plug.Conn.t(), map) :: Plug.Conn.t()
  def edit(conn, %{"id" => id}) do
    room = Conversation.get_room!(id)
    changeset = Conversation.change_room(room)
    render(conn, "edit.html", room: room, changeset: changeset)
  end

  def update(conn, %{"id" => id, "room" => room_params}) do
    room = Conversation.get_room!(id)

    room
    |> Room.changeset(room_params)
    |> Prater.Repo.update
    |> case do
    {:ok, room} ->
         conn
         |> put_flash(:info, "Room updated successful")
         |> redirect(to: Routes.room_path(conn, :show, room))
        {:error, %Ecto.Changeset{} = changeset} ->
          render(conn, "edit.html", room: room, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    room = Conversation.get_room!(id)
    {:ok, _room} = Prater.Repo.delete(room)

    conn
    |> put_flash(:info, "Room deleted successfully.")
    |> redirect(to: Routes.room_path(conn, :index))
  end

 

  defp authorize_user(conn, _params) do
    %{params: %{"id" => room_id}} = conn
    room = Conversation.get_room!(room_id)

    if Authorizer.can_manage?(conn.assigns.current_user, room) do
      conn
    else
      conn
      |> put_flash(:error, "You are not authorized to access that page")
      |> redirect(to: Routes.room_path(conn, :index))
      |> halt()
    end
  end

end
