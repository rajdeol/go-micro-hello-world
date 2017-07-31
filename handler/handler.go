package handler

import (
	greeter "github.com/rajdeol/go-micro-hello-world/proto/greeter"

	log "github.com/sirupsen/logrus"
	"golang.org/x/net/context"
)

type GreeterHandler struct {
	serviceName string
}

// NewSyncService ...
func NewGreeterHandler(serviceName string) *GreeterHandler {
	return &GreeterHandler{
		serviceName: serviceName,
	}
}

func (s *GreeterHandler) Hello(ctx context.Context, req *greeter.HelloRequest, rsp *greeter.HelloResponse) error {
	log.WithFields(log.Fields{
		"name":         s.serviceName,
		"HelloRequest": req,
	}).Info("GreeterHandler:Hello")
	rsp.Greeting = "Hello " + req.Name
	return nil
}
