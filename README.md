# RicoPing

![GitHub (pre-)release](https://img.shields.io/github/release/efcasado/rico_ping/all.svg) [![CircleCI](https://img.shields.io/circleci/project/github/efcasado/rico_ping.svg)](https://circleci.com/gh/efcasado/rico_ping)

A simple Riak Core application written in Elixir.


## Usage

This project ships with a convenience [Makefile](https://www.gnu.org/software/make/)
to ease not only the build of the project, but also the interaction with
the Docker-based cluster used for testing purposes.

The settings supported by the provided Makefile are listed in the following table.

| Option                                 | Description                                                   |
|:----------------------------------------:|---------------------------------------------------------------|
| `USE_DOCKER` (defaults to `0`, disabled) | Uses a Dockerized Elixir environment for building the project |
| `DKR_IMAGE` (defaults to `elixir:1.5`)   | Docker image used when `USE_DOCKER` is set to `1`             |

To build an Erlang/Elixir release out of this project, just run
`USE_DOCKER=1 MIX_ENV=prod make`. The resulting Erlang/Elixir release will
be in the `_build/prod` directory.

To convert the built release into a [Docker](https://www.docker.com/) image,
just run `MIX_ENV=prod make package`.

Once the Docker image is built, you are ready to spin up a cluster and start
tinkering with the application.

The following steps illustrate how to get a 5-node cluster up and running.

```bash
# Bring up 5 instances of the application
make up

make cluster
# => {ok,['rico_ping@rico_ping1.local']}

make ring
# =>
# ==================================== Nodes ====================================
# Node a: 64 (100.0%) rico_ping@rico_ping1.local
# ==================================== Ring =====================================
# aaaa|aaaa|aaaa|aaaa|aaaa|aaaa|aaaa|aaaa|aaaa|aaaa|aaaa|aaaa|aaaa|aaaa|aaaa|aaaa|
# ok

# Get the instances to form a 5-node riak core cluster
make join

make cluster
# => {ok,['rico_ping@rico_ping1.local','rico_ping@rico_ping2.local',
#         'rico_ping@rico_ping3.local','rico_ping@rico_ping4.local',
#         'rico_ping@rico_ping5.local']}

make ring
# =>
# ==================================== Nodes ====================================
# Node a: 13 ( 20.3%) rico_ping@rico_ping1.local
# Node b: 13 ( 20.3%) rico_ping@rico_ping2.local
# Node c: 13 ( 20.3%) rico_ping@rico_ping3.local
# Node d: 13 ( 20.3%) rico_ping@rico_ping4.local
# Node e: 12 ( 18.8%) rico_ping@rico_ping5.local
# ==================================== Ring =====================================
# abcd|eabc|deab|cdea|bcde|abcd|eabc|deab|cdea|bcde|abcd|eabc|deab|cdea|bcde|abcd|
# ok
```

```bash
# Send PING requests to rico_ping1
curl -X GET http://localhost:8081/ping
# => {:pong, [{707914855582156101004909840846949587645842325504, :"rico_ping@rico_ping2.local"}]}%

# Send PING requests to rico_ping2
curl -X GET http://localhost:8082/ping
# => {:pong, [{753586781748746817198774991869333432010090217472, :"rico_ping@rico_ping4.local"}]}%

# Send PING requests to rico_ping3
curl -X GET http://localhost:8083/ping
# => {:pong, [{981946412581700398168100746981252653831329677312, :"rico_ping@rico_ping4.local"}]}%

# Send PING requests to rico_ping4
curl -X GET http://localhost:8084/ping
# => {:pong, [{1255977969581244695331291653115555720016817029120, :"rico_ping@rico_ping1.local"}]}%

# Send PING requests to rico_ping5
curl -X GET http://localhost:8085/ping
# => {:pong, [{1118962191081472546749696200048404186924073353216, :"rico_ping@rico_ping5.local"}]}%
```

```bash
# Tear down the cluster
make down
```


## Author(s)

- Enrique Fernandez `<efcasado@gmail.com>`


## License

> The MIT License (MIT)
>
> Copyright (c) 2018, Enrique Fernandez
>
> Permission is hereby granted, free of charge, to any person obtaining a copy
> of this software and associated documentation files (the "Software"), to deal
> in the Software without restriction, including without limitation the rights
> to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
> copies of the Software, and to permit persons to whom the Software is
> furnished to do so, subject to the following conditions:
>
> The above copyright notice and this permission notice shall be included in
> all copies or substantial portions of the Software.
>
> THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
> IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
> FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
> AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
> LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
> OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
> THE SOFTWARE.

