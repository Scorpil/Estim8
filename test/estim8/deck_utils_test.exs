defmodule Estim8.DeckUtilsTest do
  use ExUnit.Case, async: true

  alias Estim8.DeckUtils

  test "calculate_stats_default/1 for empty list of estimates" do
    assert DeckUtils.calculate_stats_default([]) == [
             %{title: "Average", value: nil},
             %{title: "Median", value: nil}
           ]
  end
end
