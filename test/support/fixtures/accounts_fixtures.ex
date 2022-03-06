defmodule Userx.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Userx.Accounts` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        account: "some account",
        age: 42,
        bio: "some bio",
        hash_password: "some hash_password",
        name: "some name"
      })
      |> Userx.Accounts.create_user()

    user
  end
end
