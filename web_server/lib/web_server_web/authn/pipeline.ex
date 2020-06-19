defmodule WebServerWeb.Authentication.Pipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :web_server,
    error_handler: WebServerWeb.Authentication.ErrorHandler,
    module: WebServerWeb.Authentication

  plug Guardian.Plug.VerifySession, claims: %{"typ" => "access"}
  plug Guardian.Plug.LoadResource, allow_blank: true
end
