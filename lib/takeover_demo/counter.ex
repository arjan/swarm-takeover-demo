defmodule TakeoverDemo.Counter do
  use GenServer
  require Logger

  @tick_time 2000

  def start(name) do
    Swarm.register_name({:counter, name}, GenServer, :start_link, [__MODULE__, {name}])
  end

  def init({name}) do
    {:ok, {name, 0}, @tick_time}
  end

  def handle_call(:force_handoff, _from, state = {name, _}) do
    Logger.warn "Performing forced handoff for #{inspect name}"
    Swarm.Tracker.handoff({:counter, name}, state)
    {:reply, :ok, state, @tick_time}
  end

  # This is the message that your process gets when Swarm rebalances
  # the processes in the cluster.
  def handle_call({:swarm, :begin_handoff}, _from, state) do
    {:reply, {:resume, state}, state, @tick_time}
  end

  # Called when spawned a new process on this node, given a previous
  # state that was handed off to us.
  def handle_cast({:swarm, :end_handoff, state}, _state) do
    Logger.warn "Resuming process with state: #{inspect state}"
    {:noreply, state, @tick_time}
  end

  # Swarm tells us to shut down
  def handle_info({:swarm, :die}, state) do
    {:stop, :normal, state}
  end

  # Tick tick tick
  def handle_info(:timeout, state = {name, count}) do
    Logger.warn "[#{name}] #{count}"
    state = {name, count + 1}
    {:noreply, state, @tick_time}
  end
end
