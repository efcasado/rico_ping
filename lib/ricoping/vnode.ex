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

  require Logger


  ##== VNode callbacks ====================================================
  def start_vnode(idx) do
    Logger.debug "start_vnode/1"
    :riak_core_vnode_master.get_vnode_pid(idx, __MODULE__)
  end

  def init([partition]) do
    Logger.debug "init/1"
    {:ok, %{:partition => partition}}
  end

  def handle_command(ping, _sender, state = %{:partition => partition}) do
    Logger.debug "handle_command/3"
    res = {:pong, [{partition, node()}]}
    {:reply, res, state}
  end
  def handle_command(message, _sender, state) do
    Logger.debug "handle_command/3"
    {:noreply, state}
  end

  def handle_handoff_command(_message, _sender, state) do
    Logger.debug "handle_handoff_command/3"
    {:noreply, state}
  end

  def handoff_starting(_target_node, state) do
    Logger.debug "handoff_starting/2"
    {true, state}
  end

  def handoff_cancelled(state) do
    Logger.debug "handoff_cancelled/2"
    {:ok, state}
  end

  def handoff_finished(_target_node, state) do
    Logger.debug "handoff_finished/2"
    {:ok, state}
  end

  def handle_handoff_data(_data, state) do
    Logger.debug "handle_handoff_data/2"
    {:reply, :ok, state}
  end

  def encode_handoff_item(_objname, _objvalue) do
    Logger.debug "encode_handoff_item/2"
    ""
  end

  def is_empty(state) do
    Logger.debug "is_empty/1"
    {true, state}
  end

  def delete(state) do
    Logger.debug "delete/1"
    {:ok, state}
  end

  def handle_coverage(_req, _key_spaces, _sender, state) do
    Logger.debug "handle_coverage/4"
    {:stop, :not_implemented, state}
  end

  def handle_exit(_pid, _reason, state) do
    Logger.debug "handle_exit/3"
    {:noreply, state}
  end

  def terminate(_reason, _state) do
    Logger.debug "terminate/2"
    :ok
  end

end
