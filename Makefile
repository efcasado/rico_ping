###========================================================================
### File: Makefile
###
###
### Author(s):
###   - Enrique Fernandez <efcasado@gmail.com>
###
### Copyright (c) 2018, Enrique Fernandez
###========================================================================
.PHONY: all deps compile clean shell


##== Settings =============================================================
USE_DOCKER ?= 1
DKR_IMAGE  ?= elixir:1.6


##== Targets ==============================================================
all: deps compile

deps: ; mix deps.get && mix deps.compile

compile: deps ; mix compile

clean:
	rm -rf data_root
	rm -rf data.*
	rm -rf log
	rm -rf log.*
	rm -rf ring_data_dir

shell: ; iex --name ricoping@127.0.0.1 -S mix
