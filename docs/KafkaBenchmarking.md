# Kafka Benchmarking
## Testing with Kafka Basic Scripts
| Shell Name | Desp |
|-|-|
| `bin/kafka-consumer-perf-test.sh` ||
| `bin/kafka-producer-perf-test.sh` ||

## Testing the producer
```sh
bin/kafka-producer-perf-test.sh \
    --topic source_server.dbo.ACL_ESPlog \
    --num-records 300000 \
    --throughput -1 \
    --record-size 1000 \
    --producer-props \
        bootstrap.servers=kafka:9092 \
        batch.size=1000 \
```

```sh
bin/kafka-producer-perf-test.sh \
    --topic source_server.dbo.test_table \
    --num-records 30000 \
    --throughput -1 \
    --record-size 1000 \
    --producer-props \
        bootstrap.servers=kafka:9092 \
        batch.size=1000
```

**Note that** the backslash must be the last character on the line: be careful not to add any spaces after it.

### Output
```
69383 records sent, 13876.6 records/sec (13.23 MB/sec), 1573.8 ms avg latency, 2156.0 ms max latency.
77145 records sent, 15429.0 records/sec (14.71 MB/sec), 2044.8 ms avg latency, 2124.0 ms max latency.
74031 records sent, 14806.2 records/sec (14.12 MB/sec), 2052.8 ms avg latency, 2133.0 ms max latency.
72581 records sent, 14516.2 records/sec (13.84 MB/sec), 2119.5 ms avg latency, 2179.0 ms max latency.
```
```
300000 records sent, 14603.514579 records/sec (13.93 MB/sec), 1958.47 ms avg latency, 2205.00 ms max latency, 2082 ms 50th, 2154 ms 95th, 2175 ms 99th, 2204 ms 99.9th.

```

## Testing the consumer
```sh
bin/kafka-comsumer-perf-test.sh \
    --bootstrap-server kafka:9092 \
    --topic source_server.dbo.ACL_ESPlog \
    --messages 20000
```

```sh
bin/kafka-consumer-perf-test.sh \
    --bootstrap-server kafka:9092 \
    --topic source_server.dbo.test_table \
    --messages 20000
```

### Options
| Option | Description |
|-|-|
| `--bootstrap-server` | `REQUIRED` The server(s) to connect to |
| `--topic` | `REQUIRED` The topic to consume from |
| `--messages` | `REQUIRED` The number of messages to send or consume |

### Output
```sh
start.time, end.time, data.consumed.in.MB, MB.sec, data.consumed.in.nMsg, nMsg.sec, rebalance.time.ms, fetch.time.ms, fetch.MB.sec, fetch.nMsg.sec
2022-08-01 05:53:11:678, 2022-08-01 05:53:12:000, 19.1500, 59.4722, 20079, 62357.1429, 203, 119, 160.9247, 168731.0924
```
| Name | Description | Value | 
|-|-|-|
| `start.time` | Test start time. | 2022-08-01 05:53:11:678 |
| `end.time` | Test end time. | 2022-08-01 05:53:12:000 |
| `data.consumed.in.MB` | The total amount of data consumed in MB. | 19.1500 |
| `data.consumed.in.nMsg` | The total amount of data consumed in number of messages. | 20079 |
| `MB.sec` | The throughput in MB per second. | 59.4722 |
| `nMsg.sec` | The throughput in number of messages per second. | 62357.1429 |
| `rebalance.time.ms` | ... | 203 |
| `fetch.time.ms` | ... | 119 |
| `fetch.MB.sec` | ... | 160.9247 |
| `fetch.nMsg.sec` | ... | 168731.0924 |

## What is rebalance in Kafka?
- When a new consumer joins a consumer group the set of consumers attempt to "rebalance" the load to assign partitions to each consumer. 
- Rebalance is the reassignment of partition ownership among consumers with in a given consumer group.

## What is fetch in Kafka?
Fetch means that a consumer periodically sends a request to a Kafka broker in order to fetch data from it. 

## Test cases can be:
- Change the number of topics.
- Change the async batch size.
- Change message size.
- Change the number of partitions.
- Change the number of Brokers.
- Change the number of Producer/Consumer, etc.
- Change the compression Type.

## Reference
| Article | Note |
|-|-|
|[What is rebalancing in kafka?](https://stackoverflow.com/questions/30988002/what-does-rebalancing-mean-in-apache-kafka-context) | stackoverflow |
| [What is fetching in kafka?](https://www.confluent.io/blog/apache-kafka-data-access-semantics-consumers-and-membership/#:~:text=This%20means%20that%20a%20consumer,the%20form%20of%20another%20request.) | confluent document |

