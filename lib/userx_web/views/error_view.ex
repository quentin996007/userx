defmodule UserxWeb.ErrorView do
  use UserxWeb, :view

  # If you want to customize a particular status code
  # for a certain format, you may uncomment below.
  # def render("500.html", _assigns) do
  #   "Internal Server Error"
  # end

  def render("400.json", _assigns) do
    %{
      code: 400,
      message: "cast error!!!"
    }
  end

  def render("404.json", _assigns) do
    %{
      code: 404,
      message: "not_found!!!"
    }
  end

  def render("not_found_data.json", _assigns) do
    %{
      code: 404,
      message: "not_found_data.json!!!"
    }
  end

  # By default, Phoenix returns the status message from
  # the template name. For example, "404.html" becomes
  # "Not Found".
  def template_not_found(template, _assigns) do
    Phoenix.Controller.status_message_from_template(template)
  end
end
