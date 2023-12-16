#!/usr/bin/env bash

OUTPUT="/var/lib/unifi/system.properties"

echo "Creating ${OUTPUT} with external DB configuration"
{
echo "db.mongo.local=false"  \
; echo "db.mongo.uri=mongodb://${MONGO_USER}:${MONGO_PASS}@${MONGO_HOST}:${MONGO_PORT}/${MONGO_DBNAME}" \
; echo "statdb.mongo.uri=mongodb://${MONGO_USER}:${MONGO_PASS}@${MONGO_HOST}:${MONGO_PORT}/${MONGO_DBNAME}_stat" \
; echo "unifi.db.name=${MONGO_DBNAME}"
} > "${OUTPUT}"

java -Xms1024M -Xmx1024M -Dlog4j2.formatMsgNoLookups=true --add-opens java.base/java.time=ALL-UNNAMED -jar /usr/lib/unifi/lib/ace.jar start