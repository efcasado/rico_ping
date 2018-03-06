defmodule RicoPing.Mixfile do
  use Mix.Project

  def project do
    [
      app: :rico_ping,
      version: "0.1.0",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {RicoPing.Application, []}
    ]
  end

  defp deps do
    [
      {:riak_core    , github: "efcasado/riak_core"     , branch: "disable-warnings-as-errors"},
      {:riak_ensemble, github: "lasp-lang/riak_ensemble", branch: "develop", override: true},
      {:lager        , "~>3.2", override: true},
      {:cuttlefish   , github: "lasp-lang/cuttlefish"   , branch: "develop", override: true},
      {:poolboy      , github: "basho/poolboy"          , branch: "develop", override: true},
      # Release
      {:distillery, "~> 1.5"},
    ]
  end
end
