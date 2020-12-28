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
    |> filter_odd_squares
    |> build_pixel_map
    |> draw_image
    |> save_image(input)
  end

  def save_image(image, filename) do
    File.write("generated_icons/#{filename}.png", image)
  end

  def draw_image(%Loki.Image{pixel_map: pixel_map, color: color}) do
    image = :egd.create(250, 250)
    fill = :egd.color(color)

    Enum.each(pixel_map, fn {start, stop} ->
      :egd.filledRectangle(image, start, stop, fill)
    end)

    :egd.render(image)
  end

  def build_pixel_map(%Loki.Image{grid: grid} = image) do
    pixel_map =
      Enum.map(grid, fn {_code, index} ->
        horizontal = rem(index, 5) * 50
        vertical = div(index, 5) * 50

        top_left = {horizontal, vertical}
        bottom_right = {horizontal + 50, vertical + 50}

        {top_left, bottom_right}
      end)

    %Loki.Image{image | pixel_map: pixel_map}
  end

  def filter_odd_squares(%Loki.Image{grid: grid} = image) do
    filtered_grid = Enum.filter(grid, fn {value, _index} -> rem(value, 2) == 0 end)

    %Loki.Image{image | grid: filtered_grid}
  end

  def build_grid(%Loki.Image{hex_decimals: hex_decimals} = image) do
    grid =
      hex_decimals
      |> Enum.chunk_every(3, 3, :discard)
      |> Enum.map(&mirror_row/1)
      |> List.flatten()
      |> Enum.with_index()

    %Loki.Image{image | grid: grid}
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
