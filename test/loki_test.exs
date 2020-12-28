defmodule LokiTest do
  use ExUnit.Case
  doctest Loki

  test "Loki.mirror_row should correctly mirror a grid row" do
    mirrored_row = Loki.mirror_row([1, 2, 3])

    assert mirrored_row == [1, 2, 3, 2, 1]
  end

  test "Loki.pick_color should set the first three hexdecimals as the tuple color" do
    image = %Loki.Image{hex_decimals: [121, 233, 223, 68, 197, 175, 30, 184, 249, 76, 164, 86, 39, 104, 189, 86]}
    image_with_color = Loki.pick_color(image)

    assert {121, 233, 223} === image_with_color.color
  end
end
