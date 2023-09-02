defmodule Estim8.Card do
  defstruct [:label, :value]

  def new(label, value) do
    %__MODULE__{ label: label, value: value }
  end
end

defmodule Estim8.Deck do
  defstruct [:cards]

  def empty() do
    %__MODULE__{ cards: [] }
  end

  def scrum_fib() do
    %__MODULE__{ cards: [
      Estim8.Card.new("?", :unknown),
      Estim8.Card.new("0", 0),
      Estim8.Card.new("1/2", 0.5),
      Estim8.Card.new("1", 1),
      Estim8.Card.new("2", 2),
      Estim8.Card.new("3", 3),
      Estim8.Card.new("5", 5),
      Estim8.Card.new("8", 8),
      Estim8.Card.new("13", 13),
      Estim8.Card.new("20", 20),
      Estim8.Card.new("40", 40),
      Estim8.Card.new("100", 100),
    ]}
  end

  def simple() do
    %__MODULE__{ cards: [
      Estim8.Card.new("?", :unknown),
      Estim8.Card.new("0", 0),
      Estim8.Card.new("1", 1),
      Estim8.Card.new("2", 2),
      Estim8.Card.new("3", 3),
      Estim8.Card.new("4", 4),
      Estim8.Card.new("5", 5),
      Estim8.Card.new("6", 6),
      Estim8.Card.new("7", 7),
      Estim8.Card.new("8", 8),
      Estim8.Card.new("9", 9),
      Estim8.Card.new("10", 10),
    ]}
  end

  def fib() do
    %__MODULE__{ cards: [
      Estim8.Card.new("?", :unknown),
      Estim8.Card.new("0", 0),
      Estim8.Card.new("1", 1),
      Estim8.Card.new("2", 2),
      Estim8.Card.new("3", 3),
      Estim8.Card.new("5", 5),
      Estim8.Card.new("8", 8),
      Estim8.Card.new("13", 13),
      Estim8.Card.new("21", 20),
      Estim8.Card.new("34", 40),
      Estim8.Card.new("55", 100),
      Estim8.Card.new("89", 100),
    ]}
  end

  def t_shirt() do
    %__MODULE__{ cards: [
      Estim8.Card.new("?", :unknown),
      Estim8.Card.new("XS", 1),
      Estim8.Card.new("S", 2),
      Estim8.Card.new("M", 3),
      Estim8.Card.new("L", 5),
      Estim8.Card.new("XL", 8),
      Estim8.Card.new("XXL", 13),
      Estim8.Card.new("XXXL", 20),
    ]}
  end
end
