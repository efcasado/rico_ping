defmodule RicoPing.VNode do
  @behaviour :riak_core_vnode
  
  def start_vnode(idx) do
    :riak_core_vnode_master.get_vnode_pid(idx, __MODULE__)
  end

  def init([partition]) do
    {:ok, %{:partition => partition}}
  end

  def handle_command(ping, _sender, state = %{:partition => partition}) do
    {:reply, {:pong, partition}, state}
  end
  def handle_command(message, _sender, state) do
    {:noreply, state}
  end

  def handle_handoff_command(_message, _sender, state), do: {:noreply, state}

  def handoff_starting(_target_node, state), do: {true, state}

  def handoff_cancelled(state), do: {:ok, state}

  def handoff_finished(_target_node, state), do: {:ok, state}

  def handle_handoff_data(_data, state), do: {:reply, :ok, state}

  def encode_handoff_item(_objname, _objvalue), do: ""

  def is_empty(state), do: {true, state}

  def delete(state), do: {:ok, state}

  def handle_coverage(_req, _key_spaces, _sender, state), do: {:stop, :not_implemented, state}

  def handle_exit(_pid, _reason, state), do: {:noreply, state}

  def terminate(_reason, _state), do: :ok

end
