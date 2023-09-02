defmodule Estim8.RoomMonitor do
  use GenServer

  def start_link(init_arg) do
    GenServer.start_link(__MODULE__, init_arg, name: {:global, __MODULE__})
  end

  def init(_) do
    {:ok, %{views: %{}}}
  end

  def monitor(pid, view_module, meta) do
    self_pid = GenServer.whereis({:global, __MODULE__})
    GenServer.call(self_pid, {:monitor, pid, view_module, meta})
  end

  def handle_call({:monitor, pid, view_module, meta}, _, %{views: views} = state) do
    Process.monitor(pid)
    {:reply, :ok, %{state | views: Map.put(views, pid, {view_module, meta})}}
  end

  def handle_info({:DOWN, _ref, :process, pid, reason}, state) do
    {{module, meta}, new_views} = Map.pop(state.views, pid)
    module.unmount(reason, meta)
    {:noreply, %{state | views: new_views}}
  end
end
