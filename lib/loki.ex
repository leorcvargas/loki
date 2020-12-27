defmodule Loki do
  @moduledoc """
  `Loki` is a module for generating random identicons base on the
  given `String`.
  """

  def main(input) do
    input
    |> hash_input
    |> build_image_with_hex_decimals
    |> pick_color
  end

  def pick_color(image) do
    %Loki.Image{
      hex_decimals: [r, g, b | _other_hex_decimals]
    } = image

    %Loki.Image{image | color: {r, g, b}}
  end

  def build_image_with_hex_decimals(hex_decimals) do
    %Loki.Image{hex_decimals: hex_decimals}
  end

  def hash_input(input) do
    :crypto.hash(:md5, input)
    |> :binary.bin_to_list()
  end
end
