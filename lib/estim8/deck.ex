require Integer

defmodule Estim8.Card do
  defstruct [:label, :value]

  def new(label, value) do
    %__MODULE__{ label: label, value: value }
  end
end

defmodule Estim8.DeckUtils do
  def calculate_stats_default(estimates) do
    num_estimates = Enum.count(estimates)
    if num_estimates == 0 do
      [
        %{
            :title => "Average",
            :value => nil,
        },
        %{
            :title => "Median",
            :value => nil,
        }
      ]
    else
      mean = Enum.sum(estimates) / num_estimates
      median =
        if Integer.is_odd(num_estimates) do
          Enum.at(estimates, div(num_estimates, 2))
        else
          (Enum.at(estimates, div(num_estimates, 2) - 1) +
          Enum.at(estimates, div(num_estimates, 2))) / 2
        end
      [
        %{
            :title => "Average",
            :value => mean,
        },
        %{
            :title => "Median",
            :value => median,
        }
      ]
    end
  end

  def calculate_stats_tshirt(estimates) do
      estimates = Enum.sort(estimates)
      cards = Estim8.Deck.tshirt().cards
      to_label = &(Enum.find(cards, fn (card) -> card.value == trunc(&1) end).label)

      num_estimates = Enum.count(estimates)
      mean = Enum.sum(estimates) / num_estimates
      mean_index = trunc(:math.log2(mean)) + 1
      median =
        if Integer.is_odd(num_estimates) do
          estimates |> Enum.at(div(num_estimates, 2)) |> to_label.()
        else
          m1 = Enum.at(estimates, div(num_estimates, 2) - 1)
          m2 = Enum.at(estimates, div(num_estimates, 2))

          if m1 == m2 do
            m1 |> to_label.()
          else
            "#{m1 |> to_label.()}/#{m2 |> to_label.()}"
          end
        end
      [
        %{
          :title => "Average",
          :value => Enum.at(cards, mean_index).label,
        },
        %{
          :title => "Median",
          :value => median,
        }
      ]
  end
end

defmodule Estim8.Deck do
  defstruct [:n, :id, :name, :cards, :calculate_stats]

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
      ],
      calculate_stats: &Estim8.DeckUtils.calculate_stats_default/1
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
      ],
      calculate_stats: &Estim8.DeckUtils.calculate_stats_default/1
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
      ],
      calculate_stats: &Estim8.DeckUtils.calculate_stats_default/1
    }
  end

  def tshirt() do
    cards = [
      Estim8.Card.new("?", :unknown),
      Estim8.Card.new("XS", 1),
      Estim8.Card.new("S", 2),
      Estim8.Card.new("M", 4),
      Estim8.Card.new("L", 8),
      Estim8.Card.new("XL", 16),
      Estim8.Card.new("XXL", 32),
    ]
    %Estim8.Deck{
      n: 3,
      id: "tshirt",
      name: "T-Shirt: ?, XS, S, M, L, XL, XXL",
      cards: cards,
      calculate_stats: &Estim8.DeckUtils.calculate_stats_tshirt/1
    }
  end

  def list() do
    %{
      "scrum_fib" => scrum_fib(),
      "simple" => simple(),
      "fib" => fib(),
      "tshirt" => tshirt(),
    }
  end
end
