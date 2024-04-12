# Settings of docker-compose.yaml 
## Comparison Table
| File Name | Number of Zookeeper | Number of Kafka (Brokers) | CMAK | DB |
|-|-|-|-|-|
| [multi-broker-cmak-db.yaml](./multi-broker-cmak-db.yaml) | 1 | 2 | :white_check_mark: | :white_check_mark: |
| [single-broker-cmak-db.yaml](./single-broker-cmak-db.yaml) | 1 | 1 | :white_check_mark: | :white_check_mark: |
| [single-broker-db.yaml](./single-broker-db.yaml) | 1 | 1 | :x: | :white_check_mark: |

## NOTICE
"- When using the `.yaml` file to build your containers, don't forget to use the `-f, --file` option to specify an alternate compose file.
- Please ensure that the `volumes` relative path is correct for mounting the files in the container."