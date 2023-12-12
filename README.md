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
