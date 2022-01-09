defmodule GhbotDiscord.Interactions do
  alias GhbotDiscord.Interactions.ConfigInteraction
  alias GhbotDiscord.Interactions.PingInteraction

  @commands %{
    PingInteraction.command_name() => PingInteraction
  }

  @selection_modules [ConfigInteraction]

  @selections @selection_modules
              |> Enum.flat_map(fn module ->
                Enum.map(module.select_ids, fn id ->
                  {id, module}
                end)
              end)
              |> Map.new()

  @doc """
  A mapping of registered commands to the module that defines them.
  """
  def commands, do: @commands

  @doc """
  A mapping of selection ids to the module that can handle them.
  """
  def selections, do: @selections
end
