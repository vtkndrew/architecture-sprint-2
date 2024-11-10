#!/bin/bash

###
# Читаем сколько записей на shard2
###

docker compose exec -T shard2 mongosh --port 27018 <<EOF
use somedb;
db.helloDoc.countDocuments();
exit();
EOF
