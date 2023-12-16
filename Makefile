.PHONY: docker_mongo docker_unifi

ifeq ($(MONGODB_VERSION),)
MONGODB_VERSION := 4.4
endif

ifeq ($(UNIFI_VERSION),)
UNIFI_VERSION := 4.4
endif

docker_mongo:
	 docker build --build-arg MONGODB_VERSION=$(MONGODB_VERSION) . --file mongodb.Dockerfile --tag unifi-mongodb:$(MONGODB_VERSION)

docker_unifi:
	docker build . --build-arg UNIFI_VERSION=$(UNIFI_VERSION) --file unifi.Dockerfile --tag unifi:$(UNIFI_VERSION)

all: docker_unifi docker_mongo