use Mix.Config

config :riak_core,
  ring_state_dir: 'ring_data_dir',
  handoff_port: 8099,
  handoff_ip: '127.0.0.1'

config :riak_ensemble,
  synctree_backend: :synctree_ets,
  data_root: './data_root'

config :kernel,
  inet_dist_listen_min: 9000,
  inet_dist_listen_max: 9000

# import_config "#{Mix.env}.exs"
