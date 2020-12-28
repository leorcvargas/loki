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
    |> build_grid
  end

  def build_grid(%Loki.Image{hex_decimals: hex_decimals} = _image) do
    hex_decimals
    |> Enum.chunk_every(3, 3, :discard)
    |> Enum.map(fn row -> Loki.mirror_row(row) end)
  end

  def mirror_row(row) do
    [first, second | _tail] = row

    row ++ [second, first]
  end

  def pick_color(%Loki.Image{hex_decimals: [r, g, b | _tail]} = image) do
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
