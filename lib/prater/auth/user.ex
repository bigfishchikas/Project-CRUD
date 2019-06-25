defmodule Prater.Auth.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do

    has_many :rooms, Prater.Conversation.Room

    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true
    field :email, :string
    field :encrypted_password, :string
    field :username, :string

    timestamps()
  end
  @doc false
  #def changeset(user, attrs) do
  def changeset(%__MODULE__{} = user, attrs) do
    user
    |> cast(attrs, [:email, :username])
    |> validate_required([:email, :username])
    |> validate_length(:username, min: 3, max: 30)
    |> unique_constraint(:email)
    |> unique_constraint(:username)
  end

  def registration_changeset(%__MODULE__{} = user, attrs) do
    user
    |> changeset(attrs)
    |> validate_confirmation(:password)
    |> cast(attrs, [:password], [])
    |> validate_length(:password, min: 6, max: 128)
    |> encrypt_password()
  end

  defp encrypt_password(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: password}} ->
        put_change(changeset, :encrypted_password, Comeonin.Bcrypt.hashpwsalt(password))
      _ ->
        changeset
    end
  end
end
