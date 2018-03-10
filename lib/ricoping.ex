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


  ##== Auxiliary functions ================================================
  defp hash_key(key) do
    :riak_core_util.chash_key({"rico_ping", :erlang.term_to_binary(key)})
  end

end
