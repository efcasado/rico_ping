###========================================================================
### File: vnode.ex
###
###
### Author(s):
###   - Enrique Fernandez <efcasado@gmail.com>
###========================================================================
defmodule RicoPing.VNode do
  ##== Preamble ===========================================================
  @behaviour :riak_core_vnode


  ##== VNode callbacks ====================================================
  def start_vnode(idx) do
    :riak_core_vnode_master.get_vnode_pid(idx, __MODULE__)
  end

  def init([partition]) do
    {:ok, %{:partition => partition}}
  end

  def handle_command(ping, _sender, state = %{:partition => partition}) do
    res = {:pong, [{partition, node()}]}
    {:reply, res, state}
  end
  def handle_command(message, _sender, state) do
    {:noreply, state}
  end

  def handle_handoff_command(_message, _sender, state) do
    {:noreply, state}
  end

  def handoff_starting(_target_node, state) do
    {true, state}
  end

  def handoff_cancelled(state) do
    {:ok, state}
  end

  def handoff_finished(_target_node, state) do
    {:ok, state}
  end

  def handle_handoff_data(_data, state) do
    {:reply, :ok, state}
  end

  def encode_handoff_item(_objname, _objvalue) do
    ""
  end

  def is_empty(state) do
    {true, state}
  end

  def delete(state) do
    {:ok, state}
  end

  def handle_coverage(_req, _key_spaces, _sender, state) do
    {:stop, :not_implemented, state}
  end

  def handle_exit(_pid, _reason, state) do
    {:noreply, state}
  end

  def terminate(_reason, _state) do
    :ok
  end

end
