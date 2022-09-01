defmodule CryptobotWeb.FacebookControllerTest do
  use CryptobotWeb.ConnCase, async: true

  import Mox

  setup :verify_on_exit!

  test "successfully verify token", %{conn: conn} do
    params = %{
      "hub.challenge" => "1",
      "hub.mode" => "subscribe",
      "hub.verify_token" => "abc"
    }

    challenge = params["hub.challenge"] |> String.to_integer()

    conn = get(conn, Routes.facebook_path(conn, :verify_token, params))
    assert challenge == json_response(conn, 200)
  end

  test "receive_message", %{conn: conn} do
    sender_id = "1"

    params = %{
      "entry" => [
        %{
          "id" => "1",
          "messaging" => [
            %{
              "message" => %{
                "mid" => "a",
                "text" => "hi"
              },
              "recipient" => %{"id" => "2"},
              "sender" => %{"id" => sender_id}
            }
          ]
        }
      ],
      "object" => "page"
    }

    body = %{
      "first_name" => "Jackie",
      "id" => sender_id,
      "last_name" => "Chan"
    }

    expect(HttpMock, :get, fn endpoint ->
      assert endpoint =~ sender_id

      {:ok,
       %HTTPoison.Response{
         status_code: 200,
         body: Jason.encode!(body)
       }}
    end)

    post_response = %{
      "message_id" =>
        "m_izWv6z8G6r0BRQvMYJqBu3RFv8pZUNuR67iDmOcMa-djiYelhURQ54GGZ4kYGtf0_kVdXoCjlxLNjREnIq3ueg",
      "recipient_id" => "5365666476858001"
    }

    expect(HttpMock, :post, fn _, _, _ ->
      {:ok,
       %HTTPoison.Response{
         status_code: 200,
         body: Jason.encode!(post_response)
       }}
    end)

    conn = post(conn, Routes.facebook_path(conn, :receive_message), params)
    assert %{"status" => "ok", "message" => "EVENT_RECEIVED"} = json_response(conn, 200)
  end
end
