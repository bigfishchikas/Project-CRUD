defmodule Prater.Conversation.Room do
  use Ecto.Schema
  import Ecto.Changeset

  schema "rooms" do
    
    belongs_to :user, Prater.Auth.User

    field :description, :string
    field :name, :string
    field :topic, :string

    timestamps()
  end

  @doc false
  def changeset(room, attrs) do
    room
    |> cast(attrs, [:name, :description, :topic])
    |> validate_required([:name])
  end
end
