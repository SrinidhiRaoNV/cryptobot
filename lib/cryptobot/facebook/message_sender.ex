defmodule Cryptobot.Facebook.MessageSender do
  @moduledoc """
  Facebook Message Sender
  """

  alias Cryptobot.HTTP.API, as: HTTPClient

  require Logger

  @spec post_message(any) :: {:error, any} | {:ok, any}
  def post_message(message) do
    endpoint = send_endpoint()

    case post_json(endpoint, message) do
      {:ok, response} ->
        {:ok, Jason.decode!(response.body)}

      {:error, error} ->
        Logger.error("Error in sending message to bot, #{inspect(error)}")
        {:error, error}
    end
  end

  defp send_endpoint() do
    config = Application.get_env(:cryptobot, :facebook)

    %{
      base_url: base_url,
      version: version,
      endpoint: endpoint,
      page_access_token: page_access_token
    } = config

    token_path = "?access_token=#{page_access_token}"

    Path.join([base_url, version, endpoint, token_path])
  end

  defp post_json(endpoint, message) do
    headers = [{"Content-type", "application/json"}]

    with {:ok, json_msg} <- Jason.encode(message)do
      HTTPClient.post(endpoint, json_msg, headers)
    end
  end
end
