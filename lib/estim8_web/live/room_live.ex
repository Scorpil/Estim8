defmodule Estim8Web.RoomLive do
  use Estim8Web, :live_view
  import Estim8Web.Components

  @deck_list Estim8.Deck.list()

  def assign_room_data(socket, room, me) do
    room_data = if room == nil do Estim8.Room.new(nil) else Estim8.Room.get(room) end
    assign(socket, Map.merge(
      room_data,
      %{
        room: room,
        deck: Map.get(@deck_list, room_data.settings.deck_id, Estim8.Deck.empty()),
        settings_form: to_form(Estim8.RoomSettings.changeset(%Estim8.RoomSettings{}, room_data.settings)),
        me: me
      }
    ))
  end

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

      socket = assign_room_data(socket, room, me)
      {:ok, socket}
    else
      socket = assign_room_data(socket, nil, Estim8.User.new("", "Anonymous"))
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

  def handle_event("settings", %{"room_settings" => settings}, socket) do
    Estim8.Room.update_settings(socket.assigns.room, %{
      :name => settings["name"],
      :deck_id => settings["deck_id"],
    })
    {:noreply, socket}
  end

  def handle_info({:update, state}, socket) do
    {:noreply, assign(socket, Map.merge(
      state,
      %{
        me: state.users[socket.assigns.me.id],
        deck: Map.get(@deck_list, state.settings.deck_id, Estim8.Deck.empty()),
        settings_form: to_form(Estim8.RoomSettings.changeset(%Estim8.RoomSettings{}, state.settings)),
      }
    ))}
  end
end
