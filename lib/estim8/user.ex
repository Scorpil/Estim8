defmodule Estim8.User do
  defstruct [:id, :name, :card, :observer]

  def new(id, name) do
    %__MODULE__{ id: id, name: name, card: nil, observer: false }
  end

  def update_name(user, name) do
    Map.update!(user, :name, fn (_) -> name end)
  end

  def update_card(user, card) do
    Map.update!(user, :card, fn (_) -> card end)
  end

  def set_observer_status(user, observer) do
    Map.update!(user, :observer, fn (_) -> observer end)
  end
end
