defmodule Honeypot.Auth.Guardian do
  use Guardian, otp_app: :userx

  @doc """
  签署生成普通会员JWT，默认过期时间为12周。超时后再请求，会得到 invalid_token HTTP 401 的错误状态响应。

  ## Examples

      iex> Honeypot.Auth.Guardian.signin_jwt_for_member(%{username: "quentin"})
      "eyJhb..."

  """
  def signin_jwt_for_member(id) do
    {:ok, token, _claims} =
      Honeypot.Auth.Guardian.encode_and_sign(%{id: id}, %{},
        ttl: {12, :weeks},
        token_type: "member"
      )

    "Bearer " <> token
  end

  @doc """
  从当前连接解析 JWT，并返回其中 id 对应的资源
  """
  def current_resource(%Plug.Conn{} = conn) do
    user = Guardian.Plug.current_resource(conn)
    UserxWeb.UserView.render("user.json", user: user)
  end

  def subject_for_token(%{} = sub, _claims) do
    # You can use any value for the subject of your token but
    # it should be useful in retrieving the resource later, see
    # how it being used on `resource_from_claims/1` function.
    # A unique `id` is a good subject, a non-unique email address
    # is a poor subject.
    {:ok, sub}
  end

  def subject_for_token(_, _) do
    {:error, :reason_for_error}
  end

  def resource_from_claims(%{"sub" => %{"id" => id} = _sub} = _claims) do
    # Here we'll look up our resource from the claims, the subject can be
    # found in the `"sub"` key. In above `subject_for_token/2` we returned
    # the resource id so here we'll rely on that to look it up.
    # resource = MyApp.get_resource_by_id(id)
    resource = Userx.Accounts.get_user!(id)
    {:ok, resource}
  end

  # 可以根据 ID 去数据库中获取对应的资源
  # def resource_from_claims(%{"sub" => id}) do
  #   user = UserManager.get_user!(id)
  #   {:ok, user}
  # rescue
  #   Ecto.NoResultsError -> {:error, :resource_not_found}
  # end

  def resource_from_claims(_claims) do
    {:error, :reason_for_error}
  end
end
