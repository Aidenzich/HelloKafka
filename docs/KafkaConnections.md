# Connect to Apache Kafka running in Docker from different machine

## Situation Description
![situation](/docs/imgs/kafka_another_machine_connection.png)

When the initial connection succeeded, the `BrokerMetadata` shows that our client can't resolve the **KAFKA_HOST_NAME** because the client didn't know the name or service about **KAFKA_HOST_NAME** present, which cause the connection to fail.

## Solutions
Change the `advertised.listeners` configuration to the **HOST_NAME** of the machine on the LAN which running Kafka, for example:
```yaml
advertised.listeners=PLAINTEXT://localhost:9092
listeners=PLAINTEXT://0.0.0.0:9092
```
Change the `advertised.listeners` thus:
```yaml
advertised.listeners=PLAINTEXT://<KAFKA_HOST_NAME>:9092
listeners=PLAINTEXT://0.0.0.0:9092
```

The `<KAFKA_HOST_NAME>` must be set on one of the below:
1. The client machine's host file
2. The LAN's DNS host setting 
- Note that DNS is **not** case sensitive

### Host Setting in the `docker-compose.yaml` file
```yaml
version: '3'
services:
  zookeeper:
    image: quay.io/debezium/zookeeper:1.9
    ports:
     - 2181:2181
     - 2888:2888
     - 3888:3888
  kafka:
    container_name: kafka_rd
    image: quay.io/debezium/kafka:1.9
    hostname: <KAFKA_HOST_NAME>
    ports:
     - 9092:9092
    environment:
     - ZOOKEEPER_CONNECT=zookeeper:2181
     - ADVERTIESED_HOST_NAME=<KAFKA_HOST_NAME>
     - HOST_NAME=<KAFKA_HOST_NAME>
```

So if your kafka machine on the LAN called `RTDMID-RD`, then you have to set the `.yaml` config like:
```yaml
    ...
    kafka:
    container_name: kafka_rd
    image: quay.io/debezium/kafka:1.9
    hostname: RTDMID-RD                 # CHANGE
    ports:
     - 9092:9092
    environment:
     - ZOOKEEPER_CONNECT=zookeeper:2181
     - ADVERTIESED_HOST_NAME=RTDMID-RD  # CHANGE
     - HOST_NAME=RTDMID-RD              # CHANGE
```

## Reference
| Article | Link |
|-|-|
| Detailed instructions made by confluent | [link][1] |
| Discussion of connection to Kafka running in Docker | [link][2]|
| The diffrence between hostname and container_name in docker-compose.yaml | [link][3]|



[1]:https://www.confluent.io/blog/kafka-client-cannot-connect-to-broker-on-aws-on-docker-etc/
[2]:https://stackoverflow.com/questions/51630260/connect-to-kafka-running-in-docker
[3]:https://stackoverflow.com/questions/55522620/docker-compose-yml-container-name-and-hostname