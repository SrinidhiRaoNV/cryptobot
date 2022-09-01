defmodule Cryptobot.Messages.Messages do
  @moduledoc """
    Message Templates
  """

  @spec greeting({:ok, map}, any) :: %{
          message: %{attachment: map},
          messaging_type: <<_::64>>,
          recipient: %{id: any}
        }
  def greeting({:ok, %{"first_name" => first_name}}, sender_psid) do
    Agent.start_link(fn -> %{} end, name: :state_agent)

    %{
      recipient: %{
        id: sender_psid
      },
      messaging_type: "RESPONSE",
      message: %{
        attachment: %{
          type: "template",
          payload: %{
            template_type: "button",
            text:
              "Welcome to CryptoBot #{first_name} !! Do you want to search the prices by coin's ID or NAME",
            buttons: [
              %{type: "postback", title: "COIN ID", payload: "COIN_ID"},
              %{type: "postback", title: "COIN NAME", payload: "COIN_NAME"}
            ]
          }
        }
      }
    }
  end

  @spec unknwon_message(any) :: %{
          message: %{text: <<_::368>>},
          messaging_type: <<_::64>>,
          recipient: %{id: any}
        }
  def unknwon_message(sender_psid) do
    %{
      recipient: %{
        id: sender_psid
      },
      messaging_type: "RESPONSE",
      message: %{
        text: "I dont get you, let's start over, say hi again"
      }
    }
  end

  @spec coin_id(any) :: %{
          message: %{text: <<_::248>>},
          messaging_type: <<_::64>>,
          recipient: %{id: any}
        }
  def coin_id(sender_psid) do
    Agent.update(:state_agent, fn state -> Map.put(state, :search_type, :id) end)

    %{
      recipient: %{
        id: sender_psid
      },
      messaging_type: "RESPONSE",
      message: %{
        text: "Thanks, please type the coin id"
      }
    }
  end

  @spec coin_name(any) :: %{
          message: %{text: <<_::264>>},
          messaging_type: <<_::64>>,
          recipient: %{id: any}
        }
  def coin_name(sender_psid) do
    Agent.update(:state_agent, fn state -> Map.put(state, :search_type, :name) end)

    %{
      recipient: %{
        id: sender_psid
      },
      messaging_type: "RESPONSE",
      message: %{
        text: "Thanks, please type the coin name"
      }
    }
  end

  def coin_list(coins, sender_psid, search_by) do
    %{
      recipient: %{
        id: sender_psid
      },
      messaging_type: "RESPONSE",
      message: %{
        text: "Go ahead, select one from below to know its price for past 14 days",
        quick_replies: get_quick_replies(coins, search_by)
      }
    }
  end

  def prices(coin, sender_psid) do
    %{
      recipient: %{
        id: sender_psid
      },
      messaging_type: "RESPONSE",
      message: %{
        text: Cryptobot.CoinGecko.Helper.get_prices(coin)
      }
    }
  end

  defp get_quick_replies(coins, :name) do
    Enum.map(coins, fn %{"thumb" => image, "name" => name} ->
      %{
        content_type: "text",
        title: name,
        payload: "price #{String.downcase(name)}",
        image_url: image
      }
    end)
  end

  defp get_quick_replies(coins, :id) do
    Enum.map(coins, fn %{"symbol" => symbol, "thumb" => image, "id" => id} ->
      %{
        content_type: "text",
        title: symbol,
        payload: "price #{String.downcase(id)}",
        image_url: image
      }
    end)
  end
end
