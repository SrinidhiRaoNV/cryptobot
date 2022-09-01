defmodule Cryptobot.CoinGecko.Helper do
  @moduledoc """
  CoinGecko Interface Caller
  """

  alias Cryptobot.HTTP.API, as: HTTPClient

  require Logger

  @coin_count 5

  @spec search(any) :: list | {:error, any}
  def search(query) do
    query
    |> build_search_url()
    |> get()
  end

  @spec get_prices(any) :: binary
  def get_prices(coin_id) do
    config = Application.get_env(:cryptobot, :coingecko)

    %{
      base_url: base_url,
      version: version
    } = config

    query = "coins/#{coin_id}/market_chart?vs_currency=usd&days=14&interval=daily"
    history_url = Path.join([base_url, version, query])

    resp =
      case HTTPClient.get(history_url) do
        {:ok, response} ->
          {:ok, Jason.decode!(response.body)}

        {:error, error} ->
          Logger.error("Error getting prices, #{inspect(error)}")
          {:error, error}
      end

    case resp do
      {:ok, %{"prices" => prices} = _} ->
        prices
        |> Enum.take(14)
        |> Enum.map(fn [date, price] ->
          date =
            date
            |> Timex.from_unix(:millisecond)
            |> Timex.format!("{D}-{M}-{YYYY}")

          price = Float.round(price, 2)

          "Date: #{date} \nPrice: $#{price} USD"
        end)
        |> Enum.join("\n\n")

      _ ->
        {:error, :unable_to_get_prices}
    end
  end

  defp build_search_url(query) do
    config = Application.get_env(:cryptobot, :coingecko)

    %{
      base_url: base_url,
      version: version,
      search_url: search_url
    } = config

    Path.join([base_url, version, search_url, "?query=#{query}"])
  end

  defp get(endpoint) do
    case HTTPClient.get(endpoint) do
      {:ok, response} ->
        response.body |> Jason.decode!() |> parse_response()

      {:error, error} ->
        Logger.error("Error Calling CoinGecko, #{inspect(error)}")
        {:error, error}
    end
  end

  defp parse_response(%{"coins" => coins}) do
    coins |> Enum.take(@coin_count)
  end
end
