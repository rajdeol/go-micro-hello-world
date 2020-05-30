package main

import (
	log "github.com/sirupsen/logrus"

	handler "github.com/rajdeol/go-micro-hello-world/handler"
	greeter "github.com/rajdeol/go-micro-hello-world/proto/greeter"

	micro "github.com/micro/go-micro"
	"github.com/micro/go-micro/server"
	_ "github.com/micro/go-plugins/broker/rabbitmq"
	_ "github.com/micro/go-plugins/registry/kubernetes"
)

var serviceName = "service-helloworld"

func main() {
	log.WithFields(log.Fields{
		"name": serviceName,
	}).Info("Starting service")

	service := micro.NewService(
		micro.Name(serviceName),
		micro.Server(
			server.NewServer(
				server.Name(serviceName),
				server.Address(":8080"),
			),
		),
	)

	// Register Handlers
	greeter.RegisterGreeterHandler(service.Server(), handler.NewGreeterHandler(serviceName))

	// setup command line usage
	service.Init()

	// Run server
	if err := service.Run(); err != nil {
		log.Fatal(err)
	}
}
