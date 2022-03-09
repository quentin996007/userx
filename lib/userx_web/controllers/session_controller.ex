defmodule UserxWeb.SessionController do
  use UserxWeb, :controller

  alias Userx.Accounts
  alias Userx.Accounts.User
  require Logger

  action_fallback UserxWeb.FallbackController

  def sign_up(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Accounts.sign_up_user(user_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.user_path(conn, :show, user))
      |> put_view(UserxWeb.UserView)
      |> render("show.json", user: user)
    end
  end

  def sign_in(conn, %{"user" => %{"account" => account, "password" => password}}) do
    case Accounts.sign_in_user(account, password) do
      %User{} = user ->
        conn
        |> put_status(:ok)
        |> put_resp_header("location", Routes.user_path(conn, :show, user))
        |> put_view(UserxWeb.UserView)
        |> render("show.json", user: user)

      _ ->
        {:error, :sign_in_error}
    end
  end
end
