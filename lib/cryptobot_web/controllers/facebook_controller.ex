defmodule CryptobotWeb.FacebookController do
  @moduledoc """
  Facebook Controller
  """
  use CryptobotWeb, :controller

  @spec verify_token(Plug.Conn.t(), any) :: Plug.Conn.t()
  def verify_token(conn, %{"hub.mode" => "subscribe", "hub.challenge" => challenge} = _params) do
    conn
    |> put_status(200)
    |> json(String.to_integer(challenge))
  end

  def verify_token(conn, _params) do
    conn
    |> put_status(403)
    |> json(%{status: "error", message: "forbidden"})
  end

  @spec receive_message(Plug.Conn.t(), map) :: Plug.Conn.t()
  def receive_message(conn, %{"entry" => [entry], "object" => "page"} = _params) do
    Cryptobot.Messages.Handler.handle_message(entry)

    conn
    |> put_status(200)
    |> json(%{status: "ok", message: "EVENT_RECEIVED"})
  end
end
