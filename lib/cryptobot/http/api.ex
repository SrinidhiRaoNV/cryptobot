defmodule Cryptobot.HTTP.API do
  @moduledoc """
  HTTP API interface
  """

  @callback get(api :: String.t()) :: {:ok, any()} | {:error, any()}
  @callback post(api :: String.t(), payload :: any(), options :: any()) ::
              {:ok, any()} | {:error, any()}

  @spec get(any) :: any
  def get(url), do: http_client().get(url)
  @spec post(any, any, any) :: any
  def post(url, body, headers), do: http_client().post(url, body, headers)

  defp http_client() do
    Application.get_env(:cryptobot, :http_client, HTTPoison)
  end
end
