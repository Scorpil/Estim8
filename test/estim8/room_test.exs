defmodule Estim8.RoomRegistryTest do
  use ExUnit.Case, async: true

  setup do
    start_supervised(Estim8.RoomRegistry)
    :ok
  end

  test "join_or_create_and_join creates new room", _ do
    test_room_id = "room_id"
    test_user = %{id: "id", name: "name", card: nil}
    room = Estim8.RoomRegistry.join_or_create_and_join(test_room_id, test_user)
    room_data = Estim8.Room.get(room)

    assert map_size(room_data.users) == 1
    assert Map.get(room_data.users, test_user.id) == test_user

    test_user2 = %{id: "id2", name: "name2", card: nil}
    room = Estim8.RoomRegistry.join_or_create_and_join(test_room_id, test_user2)
    room_data = Estim8.Room.get(room)
    assert map_size(room_data.users) == 2
    assert Map.get(room_data.users, test_user.id) == test_user
    assert Map.get(room_data.users, test_user2.id) == test_user2

    Estim8.Room.leave(room, test_user)
    room_data = Estim8.Room.get(room)
    assert map_size(room_data.users) == 1
    assert Map.get(room_data.users, test_user2.id) == test_user2
  end
end
