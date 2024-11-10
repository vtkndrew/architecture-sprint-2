#!/bin/bash

###
# Инициализируем сервер конфигурации
###

docker compose exec -T configSrv mongosh --port 27019 <<EOF
rs.initiate(
  {
    _id : "config_server",
    configsvr: true,
    members: [
      { _id : 0, host : "configSrv:27019" }
    ]
  }
)
EOF

###
# Инициализируем шарды
###

docker compose exec -T shard1-primary mongosh --port 27018 <<EOF
rs.initiate(
  {
    _id : "shard1",
    members: [
      { _id : 0, host : "shard1-primary:27018" },
      { _id : 1, host : "shard1-repl1:27018" },
      { _id : 2, host : "shard1-repl2:27018" },
    ]
  }
)
EOF

docker compose exec -T shard2-primary mongosh --port 27018 <<EOF
rs.initiate(
  {
    _id : "shard2",
    members: [
      { _id : 0, host : "shard2-primary:27018" },
      { _id : 1, host : "shard2-repl1:27018" },
      { _id : 2, host : "shard2-repl2:27018" },
    ]
  }
)
EOF

# без этой паузы иногда бывают ошибки, видимо монго не успевает что-то до конца поднять или типа того
sleep 2

###
# Инициализируем роутер и наполняем его тестовыми данными
###

docker compose exec -T mongos_router mongosh <<EOF
sh.addShard("shard1/shard1-primary:27018");
sh.addShard("shard2/shard2-primary:27018");

sh.enableSharding("somedb");
sh.shardCollection("somedb.helloDoc", { "name" : "hashed" } );

use somedb;

for(var i = 0; i < 1000; i++) db.helloDoc.insertOne({age:i, name:"ly"+i})
db.helloDoc.countDocuments();
EOF