defmodule UserxWeb.Router do
  use UserxWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {UserxWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  # Auth Member 管道
  pipeline :auth_member do
    plug Honeypot.Auth.MemberPipeline
  end

  # 必须登录的管道
  pipeline :ensure_auth do
    plug Guardian.Plug.EnsureAuthenticated
  end

  scope "/", UserxWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  scope "/api", UserxWeb do
    pipe_through :api
    resources "/users", UserController, except: [:new, :edit]
    post "/test", UserController, :test
    post "/sign_up", SessionController, :sign_up
    post "/sign_in", SessionController, :sign_in
  end

  scope "/auth/api", UserxWeb do
    pipe_through [:api, :auth_member, :ensure_auth]
    get "/test_auth", SessionController, :test_auth
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser

      live_dashboard "/dashboard",
        metrics: UserxWeb.Telemetry,
        additional_pages: [
          flame_on: FlameOn.DashboardPage
        ]
    end
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through :browser

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
