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
      |> render(UserxWeb.UserView, "show.json", user: user)
    end
  end
end
