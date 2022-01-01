defmodule GhbotDiscordTest do
  use ExUnit.Case
  doctest GhbotDiscord

  test "greets the world" do
    assert GhbotDiscord.hello() == :world
  end
end
