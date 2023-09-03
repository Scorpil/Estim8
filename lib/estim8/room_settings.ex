defmodule Estim8.RoomSettings do
  use Ecto.Schema
  import Ecto.Changeset

  schema "room_settings" do
    field :name
    field :deck_id
  end

  def changeset(room_settings, params \\ %{}) do
    room_settings
    |> cast(params, [:name, :deck_id])
  end
end
