defmodule Honeypot.ResponseHandler do
  use UserxWeb, :controller

  def success(%Plug.Conn{} = conn, message, data) do
    response =
      Map.merge(
        %{
          status: 200,
          message: message
        },
        data
      )

    conn
    |> put_status(:ok)
    |> json(response)
  end

  def success(%Plug.Conn{} = conn, message \\ "请求处理成功") do
    response = %{
      status: 200,
      message: message
    }

    conn
    |> put_status(:ok)
    |> json(response)
  end

  def fail(%Plug.Conn{} = conn, message \\ "请求处理失败") do
    response = %{
      status: 500,
      message: message
    }

    conn
    |> put_status(:ok)
    |> json(response)
  end
end
