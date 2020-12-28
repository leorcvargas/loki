defmodule Loki do
  @moduledoc """
  `Loki` is a module for generating  identicons base on the
  given `string` input.
  """

  @doc """
  Receives a `string` input and creates a `.png` image file based
  on it.
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

  @doc """
  Receives the image in binary and saves it with the given filename.
  """
  def save_image(image, filename) do
    File.write("generated_icons/#{filename}.png", image)
  end

  @doc """
  Receives a `Loki.Image` struct and draw a image using its data.
  """
  def draw_image(%Loki.Image{pixel_map: pixel_map, color: color}) do
    image = :egd.create(250, 250)
    fill = :egd.color(color)

    Enum.each(pixel_map, fn {start, stop} ->
      :egd.filledRectangle(image, start, stop, fill)
    end)

    :egd.render(image)
  end

  @doc """
  Builds the pixel map that is going to receive the image.
  """
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

  @doc """
  Filters squares from the grid that have odd values.
  """
  def filter_odd_squares(%Loki.Image{grid: grid} = image) do
    filtered_grid = Enum.filter(grid, fn {value, _index} -> rem(value, 2) == 0 end)

    %Loki.Image{image | grid: filtered_grid}
  end

  @doc """
  Builds the grid based on the `Loki.Image` hex decimals.
  """
  def build_grid(%Loki.Image{hex_decimals: hex_decimals} = image) do
    grid =
      hex_decimals
      |> Enum.chunk_every(3, 3, :discard)
      |> Enum.map(&mirror_row/1)
      |> List.flatten()
      |> Enum.with_index()

    %Loki.Image{image | grid: grid}
  end

  @doc """
  Receives a list with three items and mirror the first two items,
  putting them at the end of the list.

  ## Examples
      iex> Loki.mirror_row([1, 2, 3])
      [1, 2, 3, 2, 1]
  """
  def mirror_row(row) do
    [first, second | _tail] = row

    row ++ [second, first]
  end

  @doc """
  Receives a `Loki.Image` struct and set the `color` propery value
  by using the first three values from `hex_decimals`.

  ## Examples
      iex> image = Loki.build_image_with_hex_decimals([121, 233, 223, 68, 197, 175, 30, 184, 249, 76, 164, 86, 39, 104, 189, 86])
      iex> Loki.pick_color(image)
      %Loki.Image{
        color: {121, 233, 223},
        grid: nil,
        hex_decimals: [121, 233, 223, 68, 197, 175, 30, 184, 249, 76, 164, 86, 39,
        104, 189, 86],
        pixel_map: nil
      }
  """
  def pick_color(%Loki.Image{hex_decimals: [r, g, b | _tail]} = image) do
    %Loki.Image{image | color: {r, g, b}}
  end

  @doc """
  Builds a `Loki.Image` struct and set the `hex_decimals` property
  value.

  ## Examples
      iex> Loki.build_image_with_hex_decimals([121, 233, 223, 68, 197, 175, 30, 184, 249, 76, 164, 86, 39, 104, 189, 86])
      %Loki.Image{
        color: nil,
        grid: nil,
        hex_decimals: [121, 233, 223, 68, 197, 175, 30, 184, 249, 76, 164, 86, 39,
        104, 189, 86],
        pixel_map: nil
      }
  """
  def build_image_with_hex_decimals(hex_decimals) do
    %Loki.Image{hex_decimals: hex_decimals}
  end

  @doc """
  Receives a string input and returns a MD5 hash as a list.

  ## Examples
      iex> Loki.hash_input("leorcvargas")
      [121, 233, 223, 68, 197, 175, 30, 184, 249, 76, 164, 86, 39, 104, 189, 86]
  """
  def hash_input(input) do
    :crypto.hash(:md5, input)
    |> :binary.bin_to_list()
  end
end
