defmodule Estim8.RoomRegistry do
  use GenServer

  ### Client API ###

  def start_link([]) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def join_or_create_and_join(room_id, user) do
    GenServer.call(__MODULE__, {:join_or_create_and_join, room_id, user})
  end

  ### Server API ###

  @impl true
  def init(_) do
    {:ok, %{}}
  end

  @impl true
  def handle_call({:join_or_create_and_join, room_id, user}, _from, rooms) do
    case Map.get(rooms, room_id) do
      nil ->
        {:ok, new_room } = Estim8.Room.start_link(room_id)
        Estim8.Room.join(new_room, user)
        {:reply, new_room, Map.put(rooms, room_id, new_room)}
      room ->
        Estim8.Room.join(room, user)
        {:reply, room, rooms}
    end
  end
end

defmodule Estim8.Room do
  use Agent

  def subscribe(room_id) do
    Phoenix.PubSub.subscribe(Estim8.PubSub, "estim8:room:#{room_id}")
  end

  def broadcast(room) do
    state = Agent.get(room, fn (state) -> state end)
    Phoenix.PubSub.broadcast(Estim8.PubSub, "estim8:room:#{state.room_id}", {:update, state})
  end

  def start_link(room_id) do
    Agent.start_link(fn -> new(room_id) end)
  end

  def new(room_id) do
    %{
      room_id: room_id,
      settings: %{:name => "", :deck_id => "scrum_fib"},
      stage: :estimation,
      users: %{},
      num_non_empty_estimations: 0,
      stats: %{
        :mean => nil,
        :median => nil,
      }
    }
  end

  def join(room, user) do
    Agent.update(room, fn (state) ->
      Map.update!(state, :users, fn (users) -> Map.put(users, user.id, user) end)
    end)
    broadcast(room)
  end

  def leave(room, user) do
    take_card(room, user.id)
    Agent.update(room, fn (state) ->
      Map.update!(state, :users, fn (users) -> Map.delete(users, user.id) end)
    end)
    broadcast(room)
  end

  def _calculate_stats(state) do
    non_empty_estimates = state.users
      |> Enum.map(fn {_, user} -> user.card && user.card.value end)
      |> Enum.filter(fn value -> is_number(value) end)
    num_non_empty_estimates = Enum.count(non_empty_estimates)
    if num_non_empty_estimates == 0 do
      %{
        :mean => nil,
        :median => nil,
      }
    else

      mean = Enum.sum(non_empty_estimates) / num_non_empty_estimates
      median = Enum.at(non_empty_estimates, div(num_non_empty_estimates, 2))
      %{
        :mean => mean,
        :median => median,
      }
    end
  end

  def reveal(room) do
    Agent.update(room, fn (state) ->
      state
      |> Map.update!(:stage, fn (_) -> :results end)
      |> Map.update!(:stats, fn (_) -> _calculate_stats(state) end)
    end)
    broadcast(room)
  end

  def reset(room) do
    Agent.update(room, fn (state) ->
      state
      |> Map.update!(:stage, fn (_) -> :estimation end)
      |> Map.update!(:users, fn (users) -> Enum.reduce(users, %{}, fn ({user_id, user}, acc) -> Map.put(acc, user_id, Estim8.User.update_card(user, nil)) end) end)
      |> Map.update!(:num_non_empty_estimations, fn (_) -> 0 end)
      |> Map.update!(:stats, fn (_) -> %{
        :mean => nil,
        :median => nil,
      } end)
    end)
    broadcast(room)
  end

  def user_namechange(room, user_id, new_name) do
    Agent.update(room, fn (state) ->
      state
      |> Map.update!(:users, fn (users) -> Map.update!(users, user_id, fn (user) -> Estim8.User.update_name(user, new_name) end) end)
    end)
    broadcast(room)
  end

  def put_card(room, user_id, card) do
    _set_estimate(room, user_id, card)
    broadcast(room)
  end

  def take_card(room, user_id) do
    _set_estimate(room, user_id, nil)
    broadcast(room)
  end

  def set_observer(room, user_id, value) do
    Agent.update(room, fn (state) ->
      state
      |> Map.update!(:users, fn (users) -> Map.update!(users, user_id, fn (user) -> Estim8.User.set_observer_status(user, value) end) end)
    end)
    if value == true do
      _set_estimate(room, user_id, nil)
    end
    broadcast(room)
  end

  def update_settings(room, settings) do
    Agent.update(room, &(Map.update!(&1, :settings, fn(_) -> settings end)))
    reset(room)
  end

  def _set_estimate(room, user_id, card) do
    Agent.update(room,
      fn (state) ->
        old_estimate = state.users[user_id].card && state.users[user_id].card.value
        new_estimate = card && card.value

        state = cond do
          old_estimate == nil && new_estimate != nil -> Map.update!(state, :num_non_empty_estimations, fn (n) -> n + 1 end)
          old_estimate != nil && new_estimate == nil -> Map.update!(state, :num_non_empty_estimations, fn (n) -> n - 1 end)
          true -> state
        end

        Map.update!(
          state,
          :users,
          fn (users) ->
            Map.update!(
              users,
              user_id,
              fn (user) ->
                user = Estim8.User.update_card(user, card)
                if card != nil do
                  Estim8.User.set_observer_status(user, false)
                else
                  user
                end
              end)
            end)
      end
    )
  end

  def get(room) do
    Agent.get(room, fn (state) -> state end)
  end
end
