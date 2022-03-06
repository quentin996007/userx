defmodule UserxWeb.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use UserxWeb, :controller

  # This clause handles errors returned by Ecto's insert/update/delete.
  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    "错误执行" |> IO.puts()

    conn
    |> put_status(:unprocessable_entity)
    |> put_view(UserxWeb.ChangesetView)
    |> render("error.json", changeset: changeset)
  end

  # This clause is an example of how to handle resources that cannot be found.
  def call(conn, {:error, :not_found}) do
    "404错误执行" |> IO.puts()

    conn
    |> put_status(:not_found)
    |> put_view(UserxWeb.ErrorView)
    |> render(:"404")
  end

  def call(conn, {:error, :not_found_data}) do
    conn
    |> put_status(200)
    |> put_view(UserxWeb.ErrorView)
    |> render("not_found_data.json")
  end
end
