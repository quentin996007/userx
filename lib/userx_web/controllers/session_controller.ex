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
          Map.merge(UserxWeb.UserView.render("user.json", user: user), %{
            jwt: Honeypot.Auth.Guardian.signin_jwt_for_member(user.id)
          })
        )

      _ ->
        conn |> ResponseHandler.fail("用户名或密码错误")
    end
  end

  def test_auth(conn, _params) do
    user = Honeypot.Auth.Guardian.current_resource(conn)
    token = Guardian.Plug.current_token(conn)
    claims = Guardian.Plug.current_claims(conn)

    conn
    |> json(%{
      user: user,
      token: token,
      claims: claims
    })
  end
end
