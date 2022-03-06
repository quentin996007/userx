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
    |> validate_required([:name, :age, :hash_password, :account, :bio])
  end
end
