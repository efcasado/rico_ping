# RicoPing
[![CircleCI](https://circleci.com/gh/efcasado/rico_ping.svg?style=svg)](https://circleci.com/gh/efcasado/rico_ping)

A simple Riak Core application written in Elixir.


## Usage

```bash
# Build the Docker image
make package
```

```bash
# Bring up a 3-node cluster
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

make join

make cluster
# => {ok,['rico_ping@rico_ping1.local','rico_ping@rico_ping2.local',
#         'rico_ping@rico_ping3.local']}
```

```bash
# Send PING requests to rico_ping1
curl -X GET http://localhost:8081/ping
# => {:pong, [{639406966332270026714112114313373821099470487552, :"rico_ping@rico_ping1.local"}]}%

# Send PING requests to rico_ping2
curl -X GET http://localhost:8082/ping
# => {:pong, [{639406966332270026714112114313373821099470487552, :"rico_ping@rico_ping1.local"}]}%

# Send PING requests to rico_ping3
curl -X GET http://localhost:8083/ping
# => {:pong, [{639406966332270026714112114313373821099470487552, :"rico_ping@rico_ping1.local"}]}%
```

```bash
# Bring down the cluster
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

