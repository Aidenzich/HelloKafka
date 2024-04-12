# Kafka Cleanup
Each topic in kafka has it's own configurable **retention time** to manage how long does kafka store data.

## Default Cleanup Settings 
The default setting when we create a kafka topic
| Parameter Name |	Default | Editable | More Info |
|-|-|-|-|-|
| `cleanup.policy` |	Delete    | No | |
| `retention.ms` |  604800000 (7 days) | Yes | Max: 63113904000 (2 years) |

## Reference
| Article Title | Link |
|-|-|
| Kafka Topic Configurations for Confluent Platform | [link](https://docs.confluent.io/platform/current/installation/configuration/topic-configs.html)|
| Topic Configures | [link](https://docs.confluent.io/cloud/current/client-apps/topics/manage.html)|
| Confirming Kafka Topic Time Based Retention Policies | [link](https://digitalis.io/blog/kafka/kafka-topic-time-based-retention-policies/) |
| Kafka Log Retention and Cleanup Policies (medium) | [link](https://medium.com/@sunny_81705/kafka-log-retention-and-cleanup-policies-c8d9cb7e09f8) |  
| Some discussion | [link](https://stackoverflow.com/questions/64306954/why-kafka-topic-queue-does-not-get-empty-when-messages-was-taken-by-consumer) |
