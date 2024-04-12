# Connector CRUD RestfulAPI

## Operations
<details><summary><strong><em>Create Source Connector</em></strong></summary>

## Create Source Connector
| Setting | Value |
|-|-|
| **METHOD** | `POST` |
| **URL** | `localhost:8083/connectors` |
| **Content-Type** | `application/json` |
| **Accept** | `*/*` |

### SendData
```json
{
    "name": "source_test1",
    "config": {
        "connector.class": "io.debezium.connector.sqlserver.SqlServerConnector",
        "database.hostname": "sqlserver",
        "database.port": "1433",
        "database.user": "sa",
        "database.password": "Password!",
        "database.dbname": "source_db",
        "snapshot.mode": "schema_only",
        "decimal.handling.mode": "String",
        "heartbeat.interval.ms": "100",
        "database.history.kafka.bootstrap.servers": "kafka:9092",
        "database.server.name": "source_server",
        "database.history.kafka.topic": "source_server.dbhistory",
        "tombstones.on.delete": "false",
        "table.include.list": "dbo.test_table"
    }
}
```

### Field Introduction
| Field Name | Desp |
|-|-|
| `name` | 	The name of our connector when we register it with a Kafka Connect service. |
| `connector.class` | The name of this SQL Server connector class. |
| `database.hostname` | The address of the SQL Server instance. |
| `database.port` | The port number of the SQL Server instance. |
| `database.user` | The name of the SQL Server user |
| `database.password` | The password for the SQL Server user |
| `database.dbname` | The name of the database to capture changes from. |
| `database.server.name` | Kafka topics to which the connector writes, the Kafka Connect schema names. |
| `database.history.kafka.topic` | The name of the database history topic where the connector will write and recover DDL statements. This topic is for internal use only and should not be used by consumers. |
| `table.include.list` | `optional` A list of all tables whose changes Debezium should capture. Any table that is not included in table.include.list is excluded from capture. **By default, the connector captures all non-system tables for the designated schemas. Must not be used with table.exclude.list.** |
| | **Working with multiple tables**: If you want to create the source connector for multiple tables, you can use `,` to add the target source table.`{dbo.table1, dbo.table2,...}` |

- Working with multiple tables
```json
{
    "name": "source_test",
    "config": {
        ...
        // ADD MULTIPLE TABLE BY ','
        "table.include.list": "dbo.ACL_ESPlog, dbo.ANOTHER_TABLE"
    }
}
```
</details>


<details><summary><strong><em>Create Sink Connector</em></strong></summary>

## Create Sink Connector
| Setting | Value |
|-|-|
| **METHOD** | `POST` |
| **URL** | `localhost:8083/connectors` |
| **Content-Type** | `application/json` |
| **Accept** | `*/*` |

### SendData
```json
{
    "name": "sink_test",
    "config": {
        "connector.class": "io.confluent.connect.jdbc.JdbcSinkConnector",        
        "tasks.max":"1",
        "auto.create": true,
        "auto.evolve":true,
        "inser.mode":"upsert",
        "batch.size":3000,
        "delete.enabled":true,
        "pk.mode":"record_key",        
        "transforms":"unwrap,route,RenameField",
        "transforms.unwrap.type":"io.debezium.transforms.ExtractNewRecordState",
        "transforms.unwrap.drop.tombstones":"false",
        "transforms.route.type":"org.apache.kafka.connect.transforms.RegexRouter",
        "transforms.route.regex":"(?:[^.]+)\\.(?:[^.]+)\\.([^.]+)",
        "transforms.route.replacement":"$1",
        "transforms.RenameField.type":"org.apache.kafka.connect.transforms.ReplaceField$Value",
        "transforms.RenameField.renames":"Id:ExternalId,Name:ExternalName",
        // The below configs need to be modified
        "connection.url": "jdbc:sqlserver://172.19.0.2:1433;databaseName=sink;encrypt=true;trustServerCertificate=true;",
        "connection.user":"sa",
        "connection.password": "Password!",
        "pk.fields":"<the-table-primary-key>",
        "topics.regex":"sql_server_test\\.dbo\\.(test_table)",
    }
}
```
### Field Introduction
| Field Name | Desp |
|-|-|
| `connector.class` | To use the JDBC sink connector, specify the name of the connector class in the connector.class configuration property. |
| `insert.mode`| The supported modes are as follows: |
| | `insert` : Use standard SQL INSERT statements. |
| | `upsert` : Use the appropriate upsert semantics for the supported target database. Must add `pk.mode` and `pk.fields` when using `upsert` mode. |
| | `update` : Use the appropriate update semantics for the target database if it is supported |
| `auto.create`| Whether to automatically create the destination table based on record schema. |
| `auto.evolve`| Whether to automatically add columns in the table schema. |
| `batch.size` | Specifies how many records to attempt to batch together for insertion into the destination table, when possible. |
#### NOTICE: The below configs need to be modified
| | |
|-|-|
| `connection.url` | Connection url to your DB, e.g. `jdbc:sqlserver://localhost;instance=SQLEXPRESS;databaseName=db_name` |
| `connection.user` | Database user. |
| `connection.password` | Database password. |
| `pk.fields` |  It needs to be consistent with the primary key of the listening table. |
| `topics.regex` | Use regular expression to give target topics. |
| | **Working with multiple tables**: Use `\|` to create the sink connector for multiple tables.  |

- Working with multiple tables
```json
{
    "name": "sink_test",
    "config": {
        ...
        // ADD MULTIPLE TABLE BY '|'
        "topics.regex":"source_server\\.dbo\\.(ACL_ESPlog) | source_server\\.dbo\\.(ANOTHER_TABLE)",
    }
}
```
</details>

<details><summary><strong><em>Read All Connectors Name</em></strong></summary>

## Read All Connectors Name
| Setting | Value |
|-|-|
| **METHOD** | `GET` |
| **URL** | `localhost:8083/connectors` |

### **Response**:
```json
// Alive connectors name
[
    "sink_test1",
    "source_test1"
]
```
</details>

<details>
<summary><strong><em>Read Connector Detail by Name</em></strong></summary>


## Read Connector Detail by Name
| Setting | Value |
|-|-|
| **METHOD** | `GET` |
| **URL** | `localhost:8083/connectors/<target-connector-name>` |
| **Accept** | `*/*` |
### **Response**:
```json
{
    "name": "sink_test1",
    "config": {
        "connector.class": "io.confluent.connect.jdbc.JdbcSinkConnector",
        "transforms.RenameField.renames": "Id:ExternalId,Name:ExternalName",
        "connection.password": "Password!",
        "tasks.max": "1",
        "batch.size": "3000",
        "transforms": "unwrap,route,RenameField",
        "topics.regex": "source_server\\.dbo\\.(test_table)",
        "inser.mode": "upsert",
        "transforms.route.type": "org.apache.kafka.connect.transforms.RegexRouter",
        "transforms.route.regex": "(?:[^.]+)\\.(?:[^.]+)\\.([^.]+)",
        "delete.enabled": "true",
        "auto.evolve": "true",
        "connection.user": "sa",
        "transforms.unwrap.drop.tombstones": "false",
        "transforms.RenameField.type": "org.apache.kafka.connect.transforms.ReplaceField$Value",
        "name": "sink_test1",
        "auto.create": "true",
        "transforms.unwrap.type": "io.debezium.transforms.ExtractNewRecordState",
        "connection.url": "jdbc:sqlserver://sqlserver:1433;databaseName=sink_db;encrypt=true;trustServerCertificate=true;",
        "transforms.route.replacement": "$1",
        "pk.mode": "record_key",
        "pk.fields": "id"
    },
    "tasks": [
        {
            "connector": "sink_test1",
            "task": 0
        }
    ],
    "type": "sink"
}
```
</details>

<details>
<summary><strong><em>Read Connector Detail by Name</em></strong></summary>

## Read Connector Status by Name
| Setting | Value |
|-|-|
| **METHOD** | `GET` |
| **URL** | `localhost:8083/connectors/<target-connector-name>/status` |
| **Accept** | `*/*` |

### **Response**:
```json
{
    "name": "sink_test1",
    "connector": {
        "state": "RUNNING",
        "worker_id": "172.19.0.5:8083"
    },
    "tasks": [
        {
            "id": 0,
            "state": "RUNNING",
            "worker_id": "172.19.0.5:8083"
        }
    ],
    "type": "sink"
}
```
</details>




<details>
<summary><strong><em>Read Connector's Plugins</em></strong></summary>

## Read Connector Plugins
| Setting | Value |
|-|-|
| **METHOD** | `GET` |
| **URL** | `localhost:8083/connectors-plugins` |
| **Accept** | `*/*` |

### **Responese**:
```json
[
    {
        "class":"io.confluent.connect.jdbc.JdbcSinkConnector","type":"sink",
        "version":"10.5.1"
    },
    {
        "class":"io.confluent.connect.jdbc.JdbcSourceConnector","type":"source",
        "version":"10.5.1"
    },
    {
        "class":"io.debezium.connector.db2.Db2Connector","type":"source",
        "version":"1.9.4.Final"
    }
    ,
    {
        "class":"io.debezium.connector.mongodb.MongoDbConnector","type":"source",
        "version":"1.9.4.Final"
    },
    {
        "class":"io.debezium.connector.mysql.MySqlConnector","type":"source",
        "version":"1.9.4.Final"
    },
    {
        "class":"io.debezium.connector.oracle.OracleConnector","type":"source",
        "version":"1.9.4.Final"
    },
    {
        "class":"io.debezium.connector.postgresql.PostgresConnector","type":"source",
        "version":"1.9.4.Final"
    },
    {
        "class":"io.debezium.connector.sqlserver.SqlServerConnector","type":"source",
        "version":"1.9.4.Final"
    },
    {
        "class":"io.debezium.connector.vitess.VitessConnector","type":"source",
        "version":"1.9.4.Final"
    },
    {
        "class":"org.apache.kafka.connect.file.FileStreamSinkConnector","type":"sink",
        "version":"3.1.0"
    },
    {
        "class":"org.apache.kafka.connect.file.FileStreamSourceConnector",
        "type":"source",
        "version":"3.1.0"
    },
    {
        "class":"org.apache.kafka.connect.mirror.MirrorCheckpointConnector",
        "type":"source",
        "version":"1"
    },
    {
        "class":"org.apache.kafka.connect.mirror.MirrorHeartbeatConnector",
        "type":"source",
        "version":"1"
    },{
        "class":"org.apache.kafka.connect.mirror.MirrorSourceConnector","type":"source",
        "version":"1"
    }
]
```
</details>

<details>
<summary><strong><em>Delete Connector By Name</em></strong></summary>

## Delete Connector By Name
- **METHOD**: `DELETE`
- **URL**: `localhost:8083/connectors/<target-connector-name>`

## Curl Cheat Table
| Operate | Command | 
|-|-|
|Create Source Connector | curl -i -X POST -H "Accept:application/json" -H "Content-Type:application/json" localhost:8083/connectors/ -d "{\"name\": \"source_test1\",\"config\": {\"connector.class\": \"io.debezium.connector.sqlserver.SqlServerConnector\",\"database.hostname\": \"sqlserver\",\"database.port\": \"1433\",\"database.user\": \"sa\",\"database.password\": \"Password!\",\"database.dbname\": \"source_db\",\"snapshot.mode\": \"schema_only\",\"decimal.handling.mode\": \"String\",\"heartbeat.interval.ms\": \"100\",\"database.history.kafka.bootstrap.servers\": \"kafka:9092\",\"database.server.name\": \"source_server\",\"database.history.kafka.topic\": \"source_server.dbhistory\",\"tombstones.on.delete\": \"false\"}}" |
| Create Sink Connector | curl -i -X POST -H "Accept:application/json" -H "Content-Type:application/json" localhost:8083/connectors/ -d  '{"name": "sink_test1","config": {"connector.class": "io.confluent.connect.jdbc.JdbcSinkConnector","connection.url": "jdbc:sqlserver://sqlserver:1433;databaseName=sink_db2;encrypt=true;trustServerCertificate=true;","connection.user":"sa","connection.password": "Password!","tasks.max":"1","auto.create": true,"auto.evolve":true,"inser.mode":"upsert","batch.size":3000,"delete.enabled":true,"pk.mode":"record_key","pk.fields":"id","topics.regex":"source_server\\.dbo\\.(test_table)","transforms":"unwrap,route,RenameField","transforms.unwrap.type":"io.debezium.transforms.ExtractNewRecordState","transforms.unwrap.drop.tombstones":"false","transforms.route.type":"org.apache.kafka.connect.transforms.RegexRouter","transforms.route.regex":"(?:[^.]+)\\.(?:[^.]+)\\.([^.]+)","transforms.route.replacement":"$1","transforms.RenameField.type":"org.apache.kafka.connect.transforms.ReplaceField$Value","transforms.RenameField.renames":"Id:ExternalId,Name:ExternalName"}}' |
</details>


### Curl Options
| param | desp |
|-|-|
| `-i` | Specify that the output should include the HTTP response headers. |
| `-X` | Changes the `METHOD` string in the HTTP request. e.g. `-X POST` |
| `-H`, ` --header` | Pass custom header(s) to server |
| `-d`, `--data` | Send data to a HTTP server in a POST request.  |


### Default Topics generated by Kafka
- __consum_offsets
- my_connect_configs
- my_connect_offsets
- my_connect_statueses

## Reference
| Article | Note |
|-|-|
| [Debezium connector for SQL Server](https://debezium.io/documentation/reference/stable/connectors/sqlserver.html) | Debezium official documents |
| [Sink Connectors Config Documents](https://docs.confluent.io/platform/current/installation/configuration/connect/sink-connect-configs.html#sinkconnectorconfigs_topics) | Confluent documents |
| [How to Deploy the Debezium SQL Server Connector to Docker](https://nielsberglund.com/2021/08/07/how-to-deploy-the-debezium-sql-server-connector-to-docker/) | - |
| [`transforms.unwrap.type` Config Documents](https://debezium.io/documentation/reference/1.1/configuration/event-flattening.html) | - |
| [Why we need `transform` to sink topics ?](https://stackoverflow.com/questions/72381349/how-to-configure-a-pre-created-kafka-topic-as-a-sink-in-kafka-connect) | stackoverflow |
| [JDBC MS-SQL config](https://docs.confluent.io/kafka-connect-jdbc/current/sink-connector/sink_config_options.html) | How to set JDBC ms-sql config|