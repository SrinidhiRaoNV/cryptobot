defmodule Cryptobot.Messages.TextHandler do
  @moduledoc """
  Facebook message text handler
  """

  alias Cryptobot.Facebook.MessageSender
  alias Cryptobot.CoinGecko.Helper, as: CoinGecko

  @spec send_response({:ok, %{:sender_psid => any, :text => any, optional(any) => any}}) ::
          {:error, any} | {:ok, any}
  def send_response({:ok, %{text: "hi", sender_psid: sender_psid}}) do
    first_name = Cryptobot.Facebook.Helper.get_firstname(sender_psid)

    first_name
    |> Cryptobot.Messages.Messages.greeting(sender_psid)
    |> Cryptobot.Facebook.MessageSender.post_message()
  end

  def send_response({:ok, %{text: "COIN_ID", sender_psid: sender_psid}}) do
    sender_psid
    |> Cryptobot.Messages.Messages.coin_id()
    |> Cryptobot.Facebook.MessageSender.post_message()
  end

  def send_response({:ok, %{text: "COIN_NAME", sender_psid: sender_psid}}) do
    sender_psid
    |> Cryptobot.Messages.Messages.coin_name()
    |> Cryptobot.Facebook.MessageSender.post_message()
  end

  def send_response({:ok, %{text: "price", coin: coin, sender_psid: sender_psid}}) do
    coin
    |> Cryptobot.Messages.Messages.prices(sender_psid)
    |> Cryptobot.Facebook.MessageSender.post_message()
  end

  def send_response({:ok, %{text: some_text, sender_psid: sender_psid}}) do
    search_by =
      Agent.get_and_update(:state_agent, fn map -> {Map.get(map, :search_type), %{}} end)

    case search_by do
      nil ->
        sender_psid
        |> Cryptobot.Messages.Messages.unknwon_message()
        |> Cryptobot.Facebook.MessageSender.post_message()

      _ ->
        some_text
        |> CoinGecko.search()
        |> Cryptobot.Messages.Messages.coin_list(sender_psid, search_by)
        |> Cryptobot.Facebook.MessageSender.post_message()
    end
  end

  def send_message(message) do
    with {:ok, _response} <- MessageSender.post_message(message) do
      :ok
    end
  end
end
