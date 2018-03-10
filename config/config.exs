use Mix.Config

config :lager,
  error_logger_redirect: false,
  error_logger_whitelist: [Logger.ErrorHandler]

config :logger,
  handle_sasl_reports: true,
  handle_otp_reports: true

config :rico_ping,
  http_port: 8080

config :riak_core,
  ring_state_dir: 'ring_data_dir',
  ring_creation_size: 16

config :kernel,
  inet_dist_listen_min: 9000,
  inet_dist_listen_max: 9100

# import_config "#{Mix.env}.exs"
