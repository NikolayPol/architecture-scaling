#!/bin/bash

###
# Инициализация сервера конфигурации
###
docker exec -it configSrv mongosh --port 27017 --quiet <<EOF
rs.initiate(
  {
    _id : "config_server",
    configsvr: true,
    members: [
      { _id : 0, host : "configSrv:27017" }
    ]
  }
);
EOF

###
# Инициализация шардов бд с репликами
###
docker exec -it shard1 mongosh --port 27018 --quiet <<EOF
rs.initiate(
    {
      _id : "shard1",
      members: [
        { _id : 0, host : "shard1:27018" },
        { _id : 1, host : "shard1-replica1:27118" },
        { _id : 2, host : "shard1-replica2:27218" }
      ]
    }
);
EOF

docker exec -it shard2 mongosh --port 27019 --quiet <<EOF
rs.initiate(
    {
      _id : "shard2",
      members: [
        { _id : 3, host : "shard2:27019" },
        { _id : 4, host : "shard2-replica1:27119" },
        { _id : 5, host : "shard2-replica2:27219" }
      ]
    }
);
EOF

###
# Инициализация роутера и настройка шардирования
###
docker exec -it mongos_router mongosh --port 27020 --quiet <<EOF
sh.addShard( "shard1/shard1:27018");
sh.addShard( "shard2/shard2:27019");
sh.enableSharding("somedb");
sh.shardCollection("somedb.helloDoc", { "name" : "hashed" } )
EOF

###
# Наполнение данными
###
docker exec -it mongos_router mongosh --port 27020 --quiet <<EOF
use somedb
for(var i = 0; i < 1000; i++) db.helloDoc.insertOne({age:i, name:"ly"+i});
db.helloDoc.countDocuments();
EOF

