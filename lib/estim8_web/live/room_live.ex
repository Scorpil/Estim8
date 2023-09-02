defmodule Estim8Web.RoomLive do
  use Estim8Web, :live_view
  import Estim8Web.Components

  def mount(params, _session, socket) do
    if connected?(socket) do
      room_id = params["id"]
      Estim8.Room.subscribe(room_id)

      connect_params = get_connect_params(socket)
      my_id = connect_params["userId"]
      my_name = connect_params["userName"]

      me = Estim8.User.new(my_id, my_name || "Anonymous")
      room = Estim8.RoomRegistry.join_or_create_and_join(room_id, me)
      Estim8.RoomMonitor.monitor(self(), __MODULE__, %{room: room, me: me})

      room_data = Estim8.Room.get(room)
      socket = assign(socket, Map.merge(
        room_data,
        %{
          room: room,
          me: me,
          deck: Estim8.Deck.simple(),
        }
      ))
      {:ok, socket}
    else
      socket = assign(socket, %{
        room: nil,
        deck: Estim8.Deck.empty(),
        me: Estim8.User.new("", "Anonymous"),
        stage: :estimation,
        users: %{},
        num_non_empty_estimations: 0,
        stats: %{
          :mean => nil,
          :median => nil,
        }
      })
      {:ok, socket}
    end
  end

  def unmount(_reason, meta) do
    Estim8.Room.leave(meta.room, meta.me)
  end

  def handle_event("reveal", _, socket) do
    Estim8.Room.reveal(socket.assigns.room)
    {:noreply, socket}
  end

  def handle_event("reset", _, socket) do
    Estim8.Room.reset(socket.assigns.room)
    {:noreply, socket}
  end

  def handle_event("put_card", %{"card-id" => card_id}, socket) do
    card = Enum.at(socket.assigns.deck.cards, String.to_integer(card_id))
    Estim8.Room.put_card(socket.assigns.room, socket.assigns.me.id, card)
    {:noreply, socket}
  end

  def handle_event("take_card", _, socket) do
    Estim8.Room.take_card(socket.assigns.room, socket.assigns.me.id)
    {:noreply, socket}
  end

  def handle_event("set_observer", %{"observer" => observer}, socket) do
    Estim8.Room.set_observer(socket.assigns.room, socket.assigns.me.id, observer == "true")
    {:noreply, socket}
  end

  def handle_event("namechange", %{"name" => name}, socket) do
    Estim8.Room.user_namechange(socket.assigns.room, socket.assigns.me.id, name)

    socket = assign(socket, %{
      me: Estim8.User.update_name(socket.assigns.me, name)
    })
    {:noreply, push_event(socket, "namechange", %{name: name})}
  end

  def handle_info({:update, state}, socket) do
    {:noreply, assign(socket, Map.merge(
      state,
      %{
        me: state.users[socket.assigns.me.id],
      }
    ))}
  end
end
