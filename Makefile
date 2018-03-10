###========================================================================
### File: Makefile
###
###
### Author(s):
###   - Enrique Fernandez <efcasado@gmail.com>
###
### Copyright (c) 2018, Enrique Fernandez
###========================================================================
.PHONY: all deps compile rel shell console package package-docker
.PHONY: up down ringready ring
.PHONY: clean clean-data


##== Settings =============================================================
MIX_ENV       ?= dev
USE_DOCKER    ?= 0
DKR_IMAGE     ?= elixir:1.5
DKR_RUN_OPTS  ?= -v "$(PWD):/$(PWD)" \
 -e "HEX_HOME=$(PWD)"                \
 -e "MIX_HOME=$(PWD)"                \
 -e "MIX_ENV=$(MIX_ENV)"             \
 -w "/$(PWD)"                        \
 --rm

CLUSTER_SIZE  ?= 5


##== Macros ===============================================================
ifeq ($(strip $(USE_DOCKER)),1)
define BIN
	@docker run $(DKR_RUN_OPTS) -it -p 8080:8080 $(DKR_IMAGE) $(1)
endef
else
define BIN
	$(1)
endef
endif

ifeq ($(strip $(USE_DOCKER)),1)
define MIX
	@docker run $(DKR_RUN_OPTS) $(DKR_IMAGE) mix local.hex --force
	@docker run $(DKR_RUN_OPTS) $(DKR_IMAGE) mix local.rebar --force
	@docker run $(DKR_RUN_OPTS) $(DKR_IMAGE) mix $(1)
endef
else
define MIX
	mix $(1)
endef
endif

ifeq ($(strip $(USE_DOCKER)),1)
define IEX
	@docker run $(DKR_RUN_OPTS) $(DKR_IMAGE) mix local.hex --force
	@docker run $(DKR_RUN_OPTS) $(DKR_IMAGE) mix local.rebar --force
	@docker run $(DKR_RUN_OPTS) -it $(DKR_IMAGE) iex $(1)
endef
else
define IEX
	iex $(1)
endef
endif


##== Targets ==============================================================
all: deps compile rel

deps:
	$(call MIX, deps.get)
	$(call MIX, deps.compile)

compile: deps ; mix compile

rel:
	$(call MIX, release)

shell:
	$(call IEX, --name ricoping@127.0.0.1 -S mix)

console:
	$(call BIN, _build/$(MIX_ENV)/rel/rico_ping/bin/rico_ping console)

package:
	docker build               \
-t rico_ping                       \
--build-arg DKR_IMAGE=$(DKR_IMAGE) \
--build-arg MIX_ENV=$(MIX_ENV)     \
.

up:
	docker network create rico_ping

	@for i in {1..$(CLUSTER_SIZE)}; do            \
		docker run                            \
                  -d                                  \
                  --rm                                \
                  --name rico_ping$$i                 \
                  --network rico_ping                 \
                  --network-alias rico_ping$$i.local  \
                  --hostname rico_ping$$i.local       \
                  -p 808$$i:8080                      \
                  rico_ping:latest ;                  \
	done

join:
	@for i in {2..$(CLUSTER_SIZE)}; do            \
		docker exec                           \
	          rico_ping$$i                        \
                  /opt/rico_ping/bin/rico_ping rpc riak_core join rico_ping@rico_ping1.local ; \
	done

cluster:
	@docker exec \
rico_ping1           \
/opt/rico_ping/bin/rico_ping rpc riak_core_status ringready

ring:
	@docker exec \
rico_ping1           \
/opt/rico_ping/bin/rico_ping rpc 'Elixir.RicoPing.Console' ring

ring_status:
	@docker exec \
rico_ping1           \
/opt/rico_ping/bin/rico_ping rpc 'Elixir.RicoPing.Console' ring_status

member_status:
	@docker exec \
rico_ping1           \
/opt/rico_ping/bin/rico_ping rpc 'Elixir.RicoPing.Console' member_status

down:
	-@for i in {1..$(CLUSTER_SIZE)}; do docker rm -f rico_ping$$i; done
	-docker network rm rico_ping

clean: clean-data
	$(call MIX, deps.clean --all)
	rm -rf deps/
	rm -rf _build/

clean-data:
	rm -rf data_root
	rm -rf data
	rm -rf data.*
	rm -rf log
	rm -rf log.*
	rm -rf ring_data_dir

	rm -rf _build/prod/rel/rico_ping/data_root
	rm -rf _build/prod/rel/rico_ping/data
	rm -rf _build/prod/rel/rico_ping/data.*
	rm -rf _build/prod/rel/rico_ping/log
	rm -rf _build/prod/rel/rico_ping/log.*
	rm -rf _build/prod/rel/rico_ping/ring_data_dir

