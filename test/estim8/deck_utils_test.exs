defmodule Estim8.DeckUtilsTest do
  use ExUnit.Case, async: true

  alias Estim8.DeckUtils

  for {estimates, expected_avg, expected_median} <- [
        {[], nil, nil},
        {[1, 3, 1], (1 + 3 + 1) / 3, 1},
        {[1, 1, 3], (1 + 1 + 3) / 3, 1},
        {[1, 3, 2, 1], (1 + 3 + 2 + 1) / 4, (1 + 2) / 2},
        {[1, 1, 2, 3], (1 + 1 + 2 + 3) / 4, (1 + 2) / 2}
      ] do
    test "calculate_stats_default/1 for estimates [" <>
           Enum.map_join(estimates, ", ", &"#{&1}") <> "]" do
      assert DeckUtils.calculate_stats_default(unquote(estimates)) == [
               %{title: "Average", value: unquote(expected_avg)},
               %{title: "Median", value: unquote(expected_median)}
             ]
    end
  end
end
