###========================================================================
### File: Makefile
###
###
### Author(s):
###   - Enrique Fernandez <efcasado@gmail.com>
###
### Copyright (c) 2018, Enrique Fernandez
###========================================================================
.PHONY: all deps compile rel shell console package package-docker clean


##== Settings =============================================================
MIX_ENV       ?= dev
USE_DOCKER    ?= 0
DKR_IMAGE     ?= elixir:1.5
DKR_RUN_OPTS  ?= -v "$(PWD):/$(PWD)" \
 -e "HEX_HOME=$(PWD)"                \
 -e "MIX_HOME=$(PWD)"                \
 -w "/$(PWD)"                        \
 --rm


##== Macros ===============================================================
ifeq ($(strip $(USE_DOCKER)),1)
define BIN
	@docker run $(DKR_RUN_OPTS) -it $(DKR_IMAGE) $(1)
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
all: deps compile

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

package: package-docker

package-docker:
	docker build --build-arg DKR_IMAGE=$(DKR_IMAGE) --build-arg MIX_ENV=$(MIX_ENV) .

clean:
	rm -rf data_root
	rm -rf data.*
	rm -rf log
	rm -rf log.*
	rm -rf ring_data_dir
	rm -rf _build/
	$(call MIX, deps.clean --all)
