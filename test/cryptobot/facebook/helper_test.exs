defmodule Cryptobot.Facebook.HelperTest do
  @moduledoc false
  use ExUnit.Case

  alias Cryptobot.Facebook.Helper

  import Mox

  setup :verify_on_exit!

  describe "Getting Firstname for the welcome message" do
    test "success - get_firstname/1" do
      sender_id = "1"

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

      assert {:ok, ^body} = Helper.get_firstname(sender_id)
    end

    test "failure - get_firstname/1" do
      sender_id = "1"

      response = {:error, :timeout}

      expect(HttpMock, :get, fn endpoint ->
        assert endpoint =~ sender_id

        {:error, :timeout}
      end)

      assert ^response = Helper.get_firstname(sender_id)
    end
  end
end
