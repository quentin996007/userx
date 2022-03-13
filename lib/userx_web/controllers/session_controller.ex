defmodule UserxWeb.SessionController do
  use UserxWeb, :controller

  alias Honeypot.ResponseHandler
  alias Userx.Accounts
  alias Userx.Accounts.User

  require Logger

  action_fallback UserxWeb.FallbackController

  @sign_up_params_schema %{
    user: [
      type: %{
        account: [type: :string, required: true, length: [min: 3, max: 20]],
        age: [type: :integer, numer: [greater_than: 0]],
        bio: :string,
        password: [type: :string, required: true, length: [min: 1]],
        name: :string
      }
    ]
  }
  def sign_up(conn, params) do
    with {:ok, better_params} <- Tarams.cast(params, @sign_up_params_schema),
         {:ok, %User{} = user} <- Accounts.sign_up_user(better_params.user) do
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
        |> ResponseHandler.success(
          "登录成功",
          UserxWeb.UserView.render("show.json", user: user)
        )

      _ ->
        conn |> ResponseHandler.fail("用户名或密码错误")
    end
  end
end
