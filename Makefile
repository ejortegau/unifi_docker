.PHONY: prereqs docker_mongo docker_unifi

init-mongo.js:
	./bin/prereqs.sh

docker_mongo: init-mongo.js
	 docker build . --file mongodb.Dockerfile --tag unifi-mongodb:4.4

docker_unifi:
	docker build . --file unifi.Dockerfile --tag unifi:8.0.7

all: docker_unifi docker_mongo