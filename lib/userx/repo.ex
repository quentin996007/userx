defmodule Userx.Repo do
  use Ecto.Repo,
    otp_app: :userx,
    adapter: Ecto.Adapters.Postgres
end
