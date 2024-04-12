# Kafka Optimization
## Determind the number of Brokers
Partition load between brokers
- The more brokers you have in your cluster, the higher performance you get since the load is spread between all of your nodes.
- A common error is that load is not distributed equally between brokers. 
- NOTE: You should **always** keep an eye on partition distribution and do re-assignments to new brokers if needed, to ensure no broker is overloaded while another is idling.

