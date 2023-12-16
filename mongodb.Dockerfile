ARG MONGODB_VERSION=4.4
FROM mongo:$MONGODB_VERSION

COPY assets/mongodb_entrypoint.sh /entrypoint.sh

ENTRYPOINT /entrypoint.sh