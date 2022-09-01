defmodule Cryptobot.Messages.MessagesTest do
  @moduledoc false
  use ExUnit.Case, async: true

  alias Cryptobot.Messages.Messages

  test "greeting/2" do
    sender_id = "1"

    expected_response = %{
      message: %{
        attachment: %{
          payload: %{
            buttons: [
              %{payload: "COIN_ID", title: "COIN ID", type: "postback"},
              %{payload: "COIN_NAME", title: "COIN NAME", type: "postback"}
            ],
            template_type: "button",
            text:
              "Welcome to CryptoBot John !! Do you want to search the prices by coin's ID or NAME"
          },
          type: "template"
        }
      },
      messaging_type: "RESPONSE",
      recipient: %{id: "1"}
    }

    assert ^expected_response = Messages.greeting({:ok, %{"first_name" => "John"}}, sender_id)
  end

  test "unknown_message/2" do
    sender_id = "1"

    expected_response = %{
      recipient: %{
        id: sender_id
      },
      messaging_type: "RESPONSE",
      message: %{
        text: "I dont get you, let's start over, say hi again"
      }
    }

    assert ^expected_response = Messages.unknwon_message(sender_id)
  end

  test "coin_id/1" do
    Agent.start_link(fn -> %{} end, name: :state_agent)
    sender_id = "1"

    expected_response = %{
      recipient: %{
        id: sender_id
      },
      messaging_type: "RESPONSE",
      message: %{
        text: "Thanks, please type the coin id"
      }
    }

    assert ^expected_response = Messages.coin_id(sender_id)
  end
end
