defmodule Prater.Conversation.Message do
  use Ecto.Schema
  import Ecto.Changeset

  schema "messages" do
    field :content, :string
    belongs_to :room, Prater.Conversation.Room
    belongs_to :user, Prater.Auth.User
    has_many :messages, Prater.Conversation.Message

    timestamps()
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:content])
    |> validate_required([:content])
  end
end
