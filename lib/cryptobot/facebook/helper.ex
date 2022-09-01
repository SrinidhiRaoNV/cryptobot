defmodule Cryptobot.Facebook.Helper do
  @moduledoc """
  Facebook Helper
  """
  alias Cryptobot.HTTP.API, as: Http

  require Logger

  @spec get_firstname(
          binary
          | maybe_improper_list(
              binary | maybe_improper_list(any, binary | []) | char,
              binary | []
            )
        ) :: {:error, any} | {:ok, any}
  def get_firstname(sender_psid) do
    profile_path = get_profile_endpoint(sender_psid)

    case Http.get(profile_path) do
      {:ok, response} ->
        {:ok, Jason.decode!(response.body)}

      {:error, error} ->
        Logger.error("Error fetching profile, #{inspect(error)}")
        {:error, error}
    end
  end

  defp get_profile_endpoint(sender_psid) do
    config = Application.get_env(:cryptobot, :facebook)

    %{
      base_url: base_url,
      version: version,
      page_access_token: page_access_token
    } = config

    query = "?access_token=#{page_access_token}"

    Path.join([base_url, version, sender_psid, query])
  end
end
