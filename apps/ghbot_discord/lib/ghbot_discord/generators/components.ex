defmodule GhbotDiscord.Generators.Components do
  import GhbotCore.Utils.MapUtils

  @spec generate_message(any, any) :: map()
  def generate_message(content \\ nil, components \\ nil) do
    data =
      %{}
      |> maybe_add({:content, content})
      |> maybe_add({:components, components})

    %{type: 4, data: data}
  end

  def generate_select(custom_id, placeholder, options) do
    %{
      type: 1,
      components: [
        %{
          type: 3,
          custom_id: custom_id,
          placeholder: placeholder,
          options: options
        }
      ]
    }
  end

  def generate_option(label, value, description) do
    %{label: label, value: value, description: description}
  end
end
