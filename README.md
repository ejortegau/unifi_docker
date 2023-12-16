# Unifi Docker Images

This repo contains scripts to build the two docker images that are necessary to
run a Unifi controller, namely:

* An image for mongodb.
* An image for the actual Unifi controller software.

They run separately due to the fact tha Unifi controller needs old mongodb versions that
are not available in the same OS the unifi controller runs on.

## Usage

### Create both images
```shell
make all
```

### Create the mongodb image
```shell
make docker_mongo
```

### Create the unifi image
```shell
make docker_unifi
```

### Run the containers
The containers need the following environment variables to be defined:

#### For both containers
* `MONGO_DBNAME`: name of the DB to be used by the Unifi controller.
* `MONGO_USER`: username to be used by Unifi controller to connect to mongodb.
* `MONGO_PASS`: password to be used by Unifi controller to connect to mongodb.

#### For the Unifi container
* `MONGO_HOST`: hostname to be used by Unifi controller to connect to mongodb.
* `MONGO_PORT`: TCP port to be used by Unifi controller to connect to mongodb.