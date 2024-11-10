#!/bin/bash

###
# Читаем сколько записей на всех репликах shard2
###

docker compose exec -T shard2-primary mongosh --port 27018 --quiet <<EOF
use somedb;
print("shard2-primary countDocs = ", db.helloDoc.countDocuments());
exit();
EOF

docker compose exec -T shard2-repl1 mongosh --port 27018 --quiet <<EOF
use somedb;
print("shard2-repl1 countDocs = ", db.helloDoc.countDocuments());
exit();
EOF

docker compose exec -T shard2-repl2 mongosh --port 27018 --quiet <<EOF
use somedb;
print("shard2-repl2 countDocs = ", db.helloDoc.countDocuments());
exit();
EOF
