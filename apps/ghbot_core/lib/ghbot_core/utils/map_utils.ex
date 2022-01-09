defmodule GhbotCore.Utils.MapUtils do
  def maybe_add(map, {key, value}, condition \\ nil) do
    if is_nil(condition) do
      if !is_nil(value) do
        Map.put(map, key, value)
      else
        map
      end
    else
      if condition do
        Map.put(map, key, value)
      else
        map
      end
    end
  end
end
