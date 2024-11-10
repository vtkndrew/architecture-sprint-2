#!/bin/bash

###
# Читаем сколько записей на всех репликах shard1
###

docker compose exec -T shard1-primary mongosh --port 27018 --quiet <<EOF
use somedb;
print("shard1-primary countDocs = ", db.helloDoc.countDocuments());
exit();
EOF

docker compose exec -T shard1-repl1 mongosh --port 27018 --quiet <<EOF
use somedb;
print("shard1-repl1 countDocs = ", db.helloDoc.countDocuments());
exit();
EOF

docker compose exec -T shard1-repl2 mongosh --port 27018 --quiet <<EOF
use somedb;
print("shard1-repl2 countDocs = ", db.helloDoc.countDocuments());
exit();
EOF
