defmodule WebServerWeb.AuthController do
  use WebServerWeb, :controller
  plug Ueberauth
  alias WebServerWeb.Authentication
  @accounts_context Application.get_env(:web_server, :accounts_context, WebServer.Accounts)

  def callback(%{assigns: %{ueberauth_auth: auth_data}} = conn, _params) do
    case @accounts_context.get_or_register(auth_data) do
      {:ok, account} ->
        conn
        |> Authentication.log_in(account)
        |> redirect(to: Routes.profile_path(conn, :show))

      {:error, _error_changeset} ->
        authentication_error(conn)
    end
  end

  def callback(%{assigns: %{ueberauth_failure: _}} = conn, _params) do
    authentication_error(conn)
  end

  defp authentication_error(conn) do
    conn
    |> put_flash(:error, "Authentication failed.")
    |> redirect(to: Routes.registration_path(conn, :new))
  end
end
