defmodule Estim8.Card do
  defstruct [:label, :value]

  def new(label, value) do
    %__MODULE__{ label: label, value: value }
  end
end

defmodule Estim8.Deck do
  defstruct [:n, :id, :name, :cards]

  def empty() do
    %__MODULE__{ name: "", cards: [] }
  end

  def scrum_fib() do
    %Estim8.Deck{
      n: 0,
      id: "scrum_fib",
      name: "Modified Fibonacci: ?, 0, 1/2, 1, 2, 3, 4, 8, 13, 20, 40, 100",
      cards: [
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
      ]
    }
  end

  def simple() do
    %Estim8.Deck{
      n: 2,
      id: "simple",
      name: "Simple: ?, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10",
      cards: [
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
      ]
    }
  end

  def fib() do
    %Estim8.Deck{
      n: 1,
      id: "fib",
      name: "Fibonacci: ?, 0, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89",
      cards: [
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
      ]
    }
  end

  def list() do
    %{
      "scrum_fib" => scrum_fib(),
      "simple" => simple(),
      "fib" => fib(),
    }
  end
end
