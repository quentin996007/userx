defmodule Honeypot.Auth.ErrorHandler do
  import Plug.Conn

  @behaviour Guardian.Plug.ErrorHandler

  @doc """
    如果 token 超时，errors 会是 {:invalid_token, :token_expired}
  """
  @impl Guardian.Plug.ErrorHandler
  def auth_error(conn, {type, _reason} = errors, _opts) do
    errors |> IO.inspect()
    body = to_string(type)

    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(401, body)
  end
end
