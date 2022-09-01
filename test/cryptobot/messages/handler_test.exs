defmodule Cryptobot.Messages.HandlerTest do
  @moduledoc false
  use ExUnit.Case, async: true

  alias Cryptobot.Messages.Handler

  import Mox

  setup :verify_on_exit!

  describe "handle_message/1" do
    test "successfully process a message event" do
      sender_id = "1"

      entry = %{
        "id" => "2",
        "messaging" => [
          %{
            "message" => %{
              "mid" => "abc",
              "text" => "hi"
            },
            "recipient" => %{"id" => "4"},
            "sender" => %{"id" => sender_id}
          }
        ]
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

      assert {:ok, ^post_response} = Handler.handle_message(entry)
    end
  end
end
