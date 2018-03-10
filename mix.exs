defmodule RicoPing.Mixfile do
  use Mix.Project

  def project do
    [
      app: :rico_ping,
      version: version(),
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      deps: deps()
    ]
  end

  def version do
    case System.cmd("git", ["log", "-n1", "--pretty='%h'"]) do
      {last, 0} ->
        last = String.trim(last)
        IO.puts last
        case System.cmd("git", ["describe", "--exact-match", "--tags", last]) do
          {"v" <> vsn, 0} -> vsn
          {_,   _} -> "0.1.0"
        end
      {_,   _} -> "0.1.0"
    end
  end
  
  def application do
    [
      extra_applications: [:logger],
      mod: {RicoPing.Application, []}
    ]
  end

  defp deps do
    [
      {:riak_core    , github: "efcasado/riak_core"     , branch: "saner-default-for-schema-dir"},
      {:riak_ensemble, github: "lasp-lang/riak_ensemble", branch: "develop", override: true},
      {:lager        , "~>3.2", override: true},
      {:cuttlefish   , github: "lasp-lang/cuttlefish"   , branch: "develop", override: true},
      {:poolboy      , github: "basho/poolboy"          , branch: "develop", override: true},
      {:plug         , "1.5.0-rc.2"},
      {:cowboy       , "~> 2.2"},
      # Release
      {:distillery, "~> 1.5"},
    ]
  end
end
