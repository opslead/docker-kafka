# Apache Kafka Container Image

[![Docker Stars](https://img.shields.io/docker/stars/opslead/kafka.svg?style=flat-square)](https://hub.docker.com/r/opslead/kafka) 
[![Docker Pulls](https://img.shields.io/docker/pulls/opslead/kafka.svg?style=flat-square)](https://hub.docker.com/r/opslead/kafka)

#### Docker Images

- [GitHub actions builds](https://github.com/opslead/docker-kafka/actions) 
- [Docker Hub](https://hub.docker.com/r/opslead/kafka)


#### Environment Variables
When you start the Kafka image, you can adjust the configuration of the instance by passing one or more environment variables either on the docker-compose file or on the docker run command line. The following environment values are provided to custom Kafka:

| Variable                  | Default Value | Description                     |
| ------------------------- | ------------- | ------------------------------- |
| `JAVA_ARGS`               |               | Configure JVM params            |
| `KAFKA_BROKER_ID`               | 1               | The id of the broker. This must be set to a unique integer for each broker.            |
| `KAFKA_NUM_NETWORK_THREADS`               |  3             | The number of threads that the server uses for receiving requests from the network and sending responses to the network            |
| `KAFKA_NUM_IO_THREADS`               |  8             | The number of threads that the server uses for processing requests, which may include disk I/O            |
| `KAFKA_SOCKET_SEND_BUFFER_BYTES`               | 102400              | The send buffer (SO_SNDBUF) used by the socket server            |
| `KAFKA_SOCKET_RECEIVE_BUFFER_BYTES`               | 102400              | The receive buffer (SO_RCVBUF) used by the socket server            |
| `KAFKA_SOCKET_REQUEST_MAX_BYTES`               | 104857600              | The maximum size of a request that the socket server will accept (protection against OOM)            |
| `KAFKA_NUM_PARTITIONS`               | 1              |  The default number of log partitions per topic. More partitions allow greater parallelism for consumption, but this will also result in more files across the brokers.           |
| `KAFKA_NUM_RECOVERY_THREADS_PER_DATA_DIR`               | 1              | The number of threads per data directory to be used for log recovery at startup and flushing at shutdown. This value is recommended to be increased for installations with data dirs located in RAID array. |
| `KAFKA_ZOOKEEPER_CONNECT`               | localhost:2181              | Zookeeper connection string (see zookeeper docs for details). This is a comma separated host:port pairs, each corresponding to a zk server. e.g. `127.0.0.1:3000,127.0.0.1:3001,127.0.0.1:3002``. You can also append an optional chroot string to the urls to specify the root directory for all kafka znodes. |
| `KAFKA_ZOOKEEPER_CONNECTION_TIMEOUT_MS`               | 18000              | Timeout in ms for connecting to zookeeper |
| `KAFKA_GROUP_INITIAL_REBALANCE_DELAY_MS`               | 0              | The following configuration specifies the time, in milliseconds, that the GroupCoordinator will delay the initial consumer rebalance. The rebalance will be further delayed by the value of `group.initial.rebalance.delay.ms` as new members join the group, up to a maximum of `max.poll.interval.ms`. The default value for this is 3 seconds. We override this to 0 here as it makes for a better out-of-the-box experience for development and testing. However, in production environments the default value of 3 seconds is more suitable as this will help to avoid unnecessary, and potentially expensive, rebalances during application startup. |



#### Run the Service

```bash
docker service create --name kafka \
  -p 9092:9092 \
  -e JAVA_ARGS="-Xms2G -Xmx6G" \
  opslead/kafka:latest
```

When running Docker Engine in swarm mode, you can use `docker stack deploy` to deploy a complete application stack to the swarm. The deploy command accepts a stack description in the form of a Compose file.

```bash
docker stack deploy -c kafka-stack.yml kafka
```

Compose file example:
```
version: "3.8"
services:
  kafka:
    image: opslead/kafka:latest
    ports:
      - 9092:9092
    deploy:
      replicas: 1
      restart_policy:
        condition: on-failure
      environment:
        - JAVA_ARGS=-Xms2G -Xmx6G

```

# Contributing
We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/opslead/docker-kafka/issues), or submit a [pull request](https://github.com/opslead/docker-kafka/pulls) with your contribution.

# Issues
If you encountered a problem running this container, you can file an [issue](https://github.com/opslead/docker-kafka/issues). For us to provide better support, be sure to include the following information in your issue:

- Host OS and version
- Docker version
- Output of docker info
- Version of this container
- The command you used to run the container, and any relevant output you saw (masking any sensitive information)
