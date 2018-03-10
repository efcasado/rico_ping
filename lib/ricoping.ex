###========================================================================
### File: ricoping.ex
###
###
### Author(s):
###   - Enrique Fernandez <efcasado@gmail.com>
###
### Copyright (c) 2018, Enrique Fernandez
###========================================================================
defmodule RicoPing do
  ##== API ================================================================
  def ping() do
    key    = :os.timestamp()
    idx    = hash_key(key)
    [node] = :riak_core_apl.get_apl(idx, 1, RicoPing)
    :riak_core_vnode_master.sync_spawn_command(node, :ping, RicoPing.VNode_master)
  end

  def ring() do
    {:ok, ring} = :riak_core_ring_manager.get_my_ring()
    :riak_core_ring.pretty_print(ring, [:legend])
  end
  
  
  ##== Auxiliary functions ================================================
  defp hash_key(key) do
    :riak_core_util.chash_key({"rico_ping", :erlang.term_to_binary(key)})
  end

end
