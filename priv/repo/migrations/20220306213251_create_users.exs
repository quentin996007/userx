defmodule Userx.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string, size: 10
      add :age, :integer
      add :hash_password, :string, null: false
      add :account, :string, null: false, size: 20
      add :bio, :string, size: 200

      timestamps()
    end

    create unique_index(:users, [:account])
  end
end
