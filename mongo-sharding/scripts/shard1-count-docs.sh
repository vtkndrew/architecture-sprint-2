#!/bin/bash

###
# Читаем сколько записей на shard1
###

docker compose exec -T shard1 mongosh --port 27018 <<EOF
use somedb;
db.helloDoc.countDocuments();
exit();
EOF
