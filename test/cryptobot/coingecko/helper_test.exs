defmodule Cryptobot.CoinGecko.HelperTest do
  @moduledoc false
  use ExUnit.Case, async: true

  alias Cryptobot.CoinGecko.Helper

  import Mox

  setup :verify_on_exit!

  describe "Cryptobot.CoinGecko.Helper.search/1" do
    test "Success - CoinGecko search API" do
      query = "btc"

      body = %{
        "coins" => [
          %{"id" => "bitcoin", "name" => "Bitcoin", "symbol" => "BTC"},
          %{"id" => "wrapped-bitcoin", "name" => "Wrapped Bitcoin", "symbol" => "WBTC"}
        ]
      }

      expect(HttpMock, :get, fn endpoint ->
        assert endpoint =~ query

        {:ok,
         %HTTPoison.Response{
           status_code: 200,
           body: Jason.encode!(body)
         }}
      end)

      response = body["coins"]

      assert ^response = Helper.search(query)
    end

    test "Failure - CoinGecko search API" do
      query = "btc"

      response = {:error, :timeout}

      expect(HttpMock, :get, fn endpoint ->
        assert endpoint =~ query

        {:error, :timeout}
      end)

      assert ^response = Helper.search(query)
    end
  end

  describe "Cryptobot.CoinGecko.Helper.get_prices/1" do
    test "Success - CoinGecko get_prices API" do
      coin_id = "btc"

      body = %{"prices" => [[1_660_867_200_000, 39.82119127647201]]}

      expect(HttpMock, :get, fn endpoint ->
        assert endpoint =~ coin_id

        {:ok,
         %HTTPoison.Response{
           status_code: 200,
           body: Jason.encode!(body)
         }}
      end)

      assert "Date: 19-8-2022 \nPrice: $39.82 USD" = Helper.get_prices(coin_id)
    end

    test "Failure - CoinGecko get_prices API" do
      coin_id = "btc"

      expect(HttpMock, :get, fn endpoint ->
        assert endpoint =~ coin_id

        {:error, :unable_to_get_prices}
      end)

      assert {:error, :unable_to_get_prices} = Helper.get_prices(coin_id)
    end
  end
end
