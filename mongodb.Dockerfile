FROM mongo:4.4

COPY assets/mongodb_entrypoint.sh /entrypoint.sh

ENTRYPOINT /entrypoint.sh