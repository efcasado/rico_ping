defmodule RicoPing.Application do
  ##== Preamble ===========================================================
  @moduledoc false

  use Application

  ##== Appliaction callbacks ==============================================
  def start(_type, _args) do
    :ok = :riak_core.register(RicoPing, [{:vnode_module, RicoPing.VNode}])
    :ok = :riak_core_node_watcher.service_up(RicoPing, self())

    import Supervisor.Spec, warn: false
    children = [
      worker(RicoPing.HTTP, []),
      worker(:riak_core_vnode_master, [RicoPing.VNode])
    ]

    opts = [strategy: :one_for_one, name: RicoPing.Supervisor]
    Supervisor.start_link(children, opts)
  end

end
