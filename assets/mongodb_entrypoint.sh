#!/usr/bin/env bash

OUTPUT="/docker-entrypoint-initdb.d/init-mongo.js"

echo "Creating ${OUTPUT} with external DB configuration"
{
echo "db.getSiblingDB(\"${MONGO_DBNAME}\").createUser({user: \"${MONGO_USER}\", pwd: \"${MONGO_PASS}\", roles: [{role: \"dbOwner\", db: \"${MONGO_DBNAME}\"}]});"
echo "db.getSiblingDB(\"${MONGO_DBNAME}_stat\").createUser({user: \"${MONGO_USER}\", pwd: \"${MONGO_PASS}\", roles: [{role: \"dbOwner\", db: \"${MONGO_DBNAME}_stat\"}]});"
} > "${OUTPUT}"

cat ${OUTPUT}

docker-entrypoint.sh mongod