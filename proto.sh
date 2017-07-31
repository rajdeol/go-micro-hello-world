#!/bin/bash

echo "Downloading library"
go get github.com/micro/protobuf/{proto,protoc-gen-go}

echo "Generating protobuf"
protoc \
    -I$GOPATH/src \
    -I/go/src/github.com/rajdeol/go-micro-hello-world/vendor \
    --go_out=plugins=micro:$GOPATH/src \
    $GOPATH/src/github.com/rajdeol/go-micro-hello-world/proto/greeter/greeter.proto