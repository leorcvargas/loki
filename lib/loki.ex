defmodule Loki do
  @moduledoc """
  `Loki` is a module for generating random identicons base on the
  given `String`.
  """

  def main(input) do
    input
    |> hash_input
  end

  def hash_input(input) do
    :crypto.hash(:md5, input)
    |> :binary.bin_to_list
  end
end
