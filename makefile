# These are the values we want to pass for VERSION and BUILD
VERSION=$(shell git describe --always --dirty)

# Setup the -ldflags option for go build here, interpolate the variable values
LDFLAGS=-ldflags \"-X main.Version=${VERSION}\"

# The path to the project in the build container
APPDIR=/go/src/github.com/$(SERVICE_IMAGE_NAME)

# The default docker command to use
DOCKERRUN=docker run -i --rm

GOLANG=golang:1.8

# images
SERVICE_IMAGE_NAME=rajdeol/go-micro-hello-world

# Pass branch when calling make, make image BRANCH=master
# default is to push latest
BRANCH=latest

################################
# Pull golang libraries
vendors:
	sh glide.sh install

################################
# Cleans our project: deletes binaries
clean:
	rm -f build/*

################################
# Build the service binaries
test:
	$(DOCKERRUN) \
		-v $(PWD):$(APPDIR) \
		-w $(APPDIR) \
		$(GOLANG) /bin/bash -c "go test ."

################################
# Build the service binaries
service: clean vendors
	$(DOCKERRUN) \
		-v $(PWD):$(APPDIR) \
		-w $(APPDIR) \
		$(GOLANG) /bin/bash -c "env CGO_ENABLED=0 GOOS=linux go build -a -o build/helloworld --installsuffix raj ."

################################
# Build the docker images
image: service-image

service-image: service
	docker build --pull  -f Dockerfile.scratch -t $(SERVICE_IMAGE_NAME) .
	docker tag $(SERVICE_IMAGE_NAME) $(SERVICE_IMAGE_NAME):$(VERSION)
	docker tag $(SERVICE_IMAGE_NAME) $(SERVICE_IMAGE_NAME):$(BRANCH)

################################
# Push the images to the docker hub
push:
	docker push $(SERVICE_IMAGE_NAME):$(VERSION)
	docker push $(SERVICE_IMAGE_NAME):$(BRANCH)

################################
# Clean up docker images
docker-clean:
	# Images created on this run
	-docker rmi $(SERVICE_IMAGE_NAME)
	-docker rmi $(SERVICE_IMAGE_NAME):$(BRANCH)
	-docker rmi $(SERVICE_IMAGE_NAME):$(VERSION)

	-docker rmi `docker images -f dangling=true -q`
	-docker run --rm -v /var/run/docker.sock:/var/run/docker.sock -v /var/lib/docker:/var/lib/docker martin/docker-cleanup-volumes

.PHONY: vendors clean test service image service-image push docker-clean