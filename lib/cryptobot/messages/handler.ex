defmodule Cryptobot.Messages.Handler do
  @moduledoc """
    Message Handler
  """

  @spec handle_message(any) :: {:error, any} | {:ok, any}
  def handle_message(entry) do
    entry
    |> parse_message
    |> Cryptobot.Messages.TextHandler.send_response()
  end

  defp parse_message(%{
         "messaging" => [
           %{
             "message" => %{"mid" => message_id, "quick_reply" => %{"payload" => text}},
             "recipient" => %{"id" => recipient_id},
             "sender" => %{"id" => sender_psid}
           }
         ]
       })
       when not is_nil(text) do
    case List.first(String.split(text)) do
      "price" ->
        [_, coin] = String.split(text)

        {:ok,
         %{
           message_id: message_id,
           text: "price",
           coin: coin,
           recipient_id: recipient_id,
           sender_psid: sender_psid
         }}

      _ ->
        {:ok,
         %{
           message_id: message_id,
           text: text,
           recipient_id: recipient_id,
           sender_psid: sender_psid
         }}
    end
  end

  defp parse_message(%{
         "messaging" => [
           %{
             "message" => %{"mid" => message_id, "text" => text},
             "recipient" => %{"id" => recipient_id},
             "sender" => %{"id" => sender_psid}
           }
         ]
       })
       when not is_nil(text) do
    {:ok,
     %{message_id: message_id, text: text, recipient_id: recipient_id, sender_psid: sender_psid}}
  end

  defp parse_message(%{
         "messaging" => [
           %{
             "postback" => %{"mid" => message_id, "payload" => text},
             "recipient" => %{"id" => recipient_id},
             "sender" => %{"id" => sender_psid}
           }
         ]
       })
       when not is_nil(text) do
    case List.first(String.split(text)) do
      "price" ->
        [_, coin] = String.split(text)

        {:ok,
         %{
           message_id: message_id,
           text: "price",
           coin: coin,
           recipient_id: recipient_id,
           sender_psid: sender_psid
         }}

      _ ->
        {:ok,
         %{
           message_id: message_id,
           text: text,
           recipient_id: recipient_id,
           sender_psid: sender_psid
         }}
    end
  end

  defp parse_message(_), do: {:error, :parse_error}
end
