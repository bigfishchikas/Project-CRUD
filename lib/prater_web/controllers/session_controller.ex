defmodule PraterWeb.SessionController do
  use PraterWeb, :controller

  alias Prater.Repo
  alias Prater.Auth.User

  def new(conn, _Params) do
    render(conn, "new.html")
  end

  def create(conn, %{"session" => %{"email" => email, "password" => password}}) do
    case Prater.Auth.sign_in(email, password) do
      {:ok, user} ->
        conn
        |> put_session(:current_user_id, user.id)
        |> put_flash(:info, "You have successfully signed in!")
        |> redirect(to: Routes.room_path(conn, :index))

      {:error, _reason} ->
        conn
        |> put_flash(:error, "Invalid Email or Password")
        |> render("new.html")
    end
  end

  def current_user(conn) do
    user_id = Plug.Conn.get_session(conn, :current_user_id)
    if user_id, do: Repo.get(User, user_id)
  end

  def user_signed_in?(conn) do
    !!current_user(conn)
  end

  def delete(conn, _params) do
    conn
    |> Prater.Auth.sign_out()
    |> redirect(to: Routes.room_path(conn, :index))
  end
end
