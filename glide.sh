#!/bin/bash

docker run --rm \
    --name=glide-$$ \
    -v $(pwd):/go/src/github.com/rajdeol/go-micro-hello-world \
    -v ~/.ssh/id_rsa:/root/.ssh/id_rsa \
    -v ~/.ssh/id_rsa.pub:/root/.ssh/id_rsa.pub \
    -v ~/.ssh/known_hosts:/root/.ssh/known_hosts \
    -w "/go/src/github.com/rajdeol/go-micro-hello-world" \
    rajdeol/golang-glide:go1.14-gl-0.13.3 ${*}
