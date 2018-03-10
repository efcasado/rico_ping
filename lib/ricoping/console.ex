defmodule RicoPing.Console do

  def ring() do
    {:ok, ring} = :riak_core_ring_manager.get_my_ring()
    :riak_core_ring.pretty_print(ring, [:legend])
  end
  
  def member_status(), do: :riak_core_console.member_status([])

  def ring_status()  , do: :riak_core_console.ring_status([])
  
end
