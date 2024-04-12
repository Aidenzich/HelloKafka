# Make docker containers
 docker-compose up -d 

# Wait for containers to start
sleep 10

# Create the target topic for solve cold start issue with Kafka Connect
docker exec kafka_rd bin/kafka-topics.sh  --bootstrap-server kafka:9092 --create --topic source_server.dbo.ACL_ESPlog

# Create source connectors
curl --location --request POST 'localhost:9083/connectors' \
--header 'Content-Type: application/json' \
-d '{
    "name": "source_test",
    "config": {
        "connector.class": "io.debezium.connector.sqlserver.SqlServerConnector",
        "database.hostname": "10.11.36.178",
        "database.port": "1433",
        "database.user": "mis_user",
        "database.password": "1qaz!QAZ",
        "database.dbname": "SinoDBHistory",
        "snapshot.mode": "schema_only",
        "decimal.handling.mode": "String",
        "heartbeat.interval.ms": "10",
        "database.history.kafka.bootstrap.servers": "kafka:9092",
        "database.server.name": "source_server",
        "database.history.kafka.topic": "source_server.dbhistory",
        "tombstones.on.delete": "false",
        "table.include.list": "dbo.ACL_ESPlog"
    }
}'

# Create sink connectors
curl --location --request POST 'localhost:9083/connectors' \
--header 'Content-Type: application/json' \
-d '{
    "name": "sink_test",
    "config": {
        "connector.class": "io.confluent.connect.jdbc.JdbcSinkConnector",
        "connection.url": "jdbc:sqlserver://10.11.36.178:1433;databaseName=Kafka;encrypt=true;trustServerCertificate=true;",
        "connection.user":"mis_user",
        "connection.password": "1qaz!QAZ",
        "tasks.max":"1",
        "auto.create": true,
        "auto.evolve":true,
        "insert.mode":"upsert",
        "batch.size":3000,
        "delete.enabled":true,
        "pk.mode":"record_key",
        "pk.fields":"eventId",
        "topics.regex":"source_server\\.dbo\\.(ACL_ESPlog)",
        "transforms":"unwrap,route,RenameField",
        "transforms.unwrap.type":"io.debezium.transforms.ExtractNewRecordState",
        "transforms.unwrap.drop.tombstones":"false",
        "transforms.route.type":"org.apache.kafka.connect.transforms.RegexRouter",
        "transforms.route.regex":"(?:[^.]+)\\.(?:[^.]+)\\.([^.]+)",
        "transforms.route.replacement":"$1",
        "transforms.RenameField.type":"org.apache.kafka.connect.transforms.ReplaceField$Value",
        "transforms.RenameField.renames":"Id:ExternalId,Name:ExternalName"     
    }
}'