defmodule PraterWeb.RoomChannel do
  use PraterWeb, :channel


  alias Prater.Repo
  alias Prater.Auth.User
  alias PraterWeb.Presence

  def join("room:" <> room_id, _params, socket) do
    send(self(), :after_join)
    {:ok, %{channel: "room:#{room_id}"}, assign(socket, :room_id, room_id)}
  end

  
  def handle_info(:after_join, socket) do
    push socket, "presence_state", Presence.list(socket)

    user = Repo.get(User, socket.assigns[:current_user_id])

    {:ok, _} = Presence.track(socket, "user:#{user.id}", %{
      user_id: user.id,
      username: user.username
    })

    {:noreply, socket}
  end

  def handle_in("user:typing", %{"typing" => typing}, socket) do
    user = Repo.get(User, socket.assigns[:current_user_id])

    {:ok, _} = Presence.update(socket, "user:#{user.id}", %{
      typing: typing,
      user_id: user.id,
      username: user.username
    })

    {:reply, :ok, socket}
  end

end

