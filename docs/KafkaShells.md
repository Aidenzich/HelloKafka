# Kafka Shell Commands
## Cheat Table
| Operate | shell |
|-|-|
| List all topics in kafka | `bin/kafka-topics.sh --bootstrap-server kafka:9092 --list` |
| Get all describe of topics | `bin/kafka-topics.sh --bootstrap-server kafka:9092 --describe` |
| Get specific topic's describe | `bin/kafka-topics.sh --bootstrap-server kafka:9092 --topic <specific-topic> --describe` |
| Open Topic Listening | `bin/kafka-console-consumer.sh --bootstrap-server kafka:9092 --topic <specific-topic>` |
| Open Topic Listening with history logs | `bin/kafka-console-consumer.sh --bootstrap-server kafka:9092 --topic <specific-topic> --from-beginning` |
| Show the version of the Kafka broker | `bin/kafka-broker-api-versions.sh --bootstrap-server kafka:9092 --version` |
| Show partition offsets of a Kafka topic | `bin/kafka-run-class.sh kafka.tools.GetOffsetShell --broker-list kafka:9092 --topic <specific-topic>` |
- The `--bootstrap-server`'s value `kafka` is the alias of broker's ip.

<details>
<summary><strong><em>bin/kafka-topics.sh</em></strong></summary>

| options | desp |
|-|-|
| `--list` | List all available topics. |
| `--describe` |  List details for the given topics. |
| `--create` | Create a new topic  |
| `--delete` | Delete a topic |
| `--topic`| The topic to create, alter, describe or delete. It also accepts a regular expression, except for --create option. Put topic name in double quotes and use the '\' prefix to escape regular expression symbols; e.g. "test\.topic". |
| `--if-not-exists` | Create a Kafka topic in case the topic doesn’t exist |
| ~~`--zookeeper`~~| Option zookeeper is **deprecated**, use --bootstrap-server instead. |
</details>


<details>
<summary><strong><em>bin/kafka-run-class.sh</em></strong></summary>

### Show partition offsets of a Kafka topic
```
bin/kafka-run-class.sh kafka.tools.GetOffsetShell --broker-list localhost:9092 --topic <specific-topic>
```
#### Output
- **format**    
    `<topicname>:<partition-id>:<offset>`
    
- **example**
    ```
    my-first-topic:0:3
    my-first-topic:1:3
    my-first-topic:2:3
    ```
</details>
