defmodule UserxWeb.UserView do
  use UserxWeb, :view
  alias UserxWeb.UserView

  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{
      id: user.id,
      name: user.name,
      age: user.age,
      hash_password: user.hash_password,
      account: user.account,
      bio: user.bio
    }
  end
end
