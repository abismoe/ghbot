defmodule GhbotDiscord.MessageHandlers.PingHandler do
  @moduledoc """
  Handles a ping message.
  """

  alias Nostrum.Api
  alias Nostrum.Cache.Me
  alias Nostrum.Struct.Message
  alias Nostrum.Struct.User

  def handle(%Message{content: content, mentions: [%User{id: id}]} = message) do
    me = Me.get()

    if id == me.id && String.ends_with?(content, "ping") do
      Api.create_message(message.channel_id, "Pong!")
    else
      :ignore
    end
  end

  def handle(_) do
    :ignore
  end
end
