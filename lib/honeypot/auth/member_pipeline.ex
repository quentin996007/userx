defmodule Honeypot.Auth.MemberPipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :auth_me,
    error_handler: Honeypot.Auth.ErrorHandler,
    module: Honeypot.Auth.Guardian

  # If there is a session token, restrict it to an member token and validate it
  plug Guardian.Plug.VerifySession, claims: %{"typ" => "member"}
  # If there is an authorization header, restrict it to an member token and validate it
  plug Guardian.Plug.VerifyHeader, claims: %{"typ" => "member"}
  # Load the user if either of the verifications worked
  plug Guardian.Plug.LoadResource, allow_blank: true
end
