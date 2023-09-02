defmodule Estim8.RoomRegistryTest do
  use ExUnit.Case, async: true

  setup do
    start_supervised(Estim8.RoomRegistry)
    :ok
  end

  test "join_or_create_and_join creates new room", _ do
    test_room_id = "room_id"
    test_user = %{id: "id", name: "name"}
    room = Estim8.RoomRegistry.join_or_create_and_join(test_room_id, test_user)
    room_data = Estim8.Room.get(room)
    assert room_data.users == [test_user]

    test_user2 = %{id: "id2", name: "name2"}
    room = Estim8.RoomRegistry.join_or_create_and_join(test_room_id, test_user2)
    room_data = Estim8.Room.get(room)
    assert room_data.users == [test_user2, test_user]

    Estim8.Room.leave(room, test_user.id)
    room_data = Estim8.Room.get(room)
    assert room_data.users == [test_user2]
  end
end
