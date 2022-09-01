defmodule Cryptobot.Facebook.MessageSenderTest do
  @moduledoc false
  use ExUnit.Case

  alias Cryptobot.Facebook.MessageSender

  import Mox

  setup :verify_on_exit!

  describe "post_message/1" do
    test "success - post message to Facebook" do
      sender_id = "2"

      message = %{
        "message" => %{"text" => "Hi John! Welcome!\n"},
        "messaging_type" => "RESPONSE",
        "recipient" => %{"id" => sender_id}
      }

      json_message = Jason.encode!(message)

      body = %{
        "message_id" => "1",
        "recipient_id" => sender_id
      }

      expect(HttpMock, :post, fn _endpoint, ^json_message, _opts ->
        {:ok,
         %HTTPoison.Response{
           status_code: 200,
           body: Jason.encode!(body)
         }}
      end)

      assert {:ok, ^body} = MessageSender.post_message(message)
    end

    test "failure - post message to Facebook" do
      sender_id = "2"

      message = %{
        "message" => %{"text" => "Ola"},
        "messaging_type" => "RESPONSE",
        "recipient" => %{"id" => sender_id}
      }

      json_message = Jason.encode!(message)

      response = {:error, :timeout}

      expect(HttpMock, :post, fn _endpoint, ^json_message, _opts ->
        {:error, :timeout}
      end)

      assert ^response = MessageSender.post_message(message)
    end
  end
end
