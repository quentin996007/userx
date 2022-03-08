defmodule Userx.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :account, :string
    field :age, :integer
    field :bio, :string
    field :hash_password, :string
    field :password, :string, virtual: true
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :age, :hash_password, :account, :bio])
    |> validate_required([:hash_password, :account])
    |> unique_constraint(:account)
  end

  @doc false
  def changeset_password(user, attrs) do
    user
    |> cast(attrs, [:name, :age, :password, :account, :bio])
    |> validate_required([:password, :account])
    |> unique_constraint(:account)
    |> hash_password
  end

  defp hash_password(%Ecto.Changeset{changes: %{password: password}} = changeset) do
    changeset |> put_change(:hash_password, Honeypot.Encrypt.hash_password(password))
  end

  defp hash_password(changeset) do
    changeset
  end
end
