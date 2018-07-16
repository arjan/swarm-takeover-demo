defmodule TakeoverDemo do
  @moduledoc """
  Documentation for TakeoverDemo.
  """

  @doc """
  Hand off all local processes
  """
  def force_handoff do
    for {{:counter, _name}, pid} <- Swarm.registered(), :erlang.node(pid) == node() do
        GenServer.call(pid, :force_handoff)
    end
  end
end
