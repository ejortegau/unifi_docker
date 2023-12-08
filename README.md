# Unifi Docker Images

This repo contains scripts to build the two docker images that are necessary to
run a Unifi controller, namely:

* An image for mongodb.
* An image for the actual Unifi controller software.

They run separately due to the fact tha Unifi controller needs old mongodb versions that
are not available in the same OS the unifi controller runs on.

## Usage

### Prerequisistes
For one of the targets of the makefile to work, we need to be able to fetch secrets from AWS's secret manager. This
requires us to set up credentials using https://github.com/ejortegau/aws_cli_bootstrap.

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
