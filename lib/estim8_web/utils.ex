defmodule StringGenerator do
  @chars "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789" |> String.graphemes()

  def generate(length) do
    Enum.reduce(1..length, "", fn(_, acc) ->
      acc <> Enum.random(@chars)
    end)
  end

end

defmodule Estim8Web.Utils do
  def generate_room_id() do
    StringGenerator.generate(8)
  end

  def generate_user_id() do
    StringGenerator.generate(12)
  end

  def mean(list) do
    Enum.sum(list) / length(list)
  end

  def median(list) do
    Enum.at(Enum.sort(list), div(length(list), 2))
  end
end
