FROM azul/zulu-openjdk:11

LABEL maintainer="opslead"
LABEL repository="https://github.com/opslead/docker-kafka"

ARG KAFKA_VERSION

WORKDIR /opt/kafka

ENV KAFKA_USER="kafka" \
    KAFKA_UID="8983" \
    KAFKA_GROUP="kafka" \
    KAFKA_GID="8983" \
    KAFKA_BROKER_ID="0" \
    KAFKA_LISTENERS="PLAINTEXT://:9092" \
    KAFKA_ADVERTISED_LISTENERS="PLAINTEXT://localhost:9092" \
    KAFKA_NUM_NETWORK_THREADS="3" \
    KAFKA_NUM_IO_THREADS="8" \
    KAFKA_SOCKET_SEND_BUFFER_BYTES="102400" \
    KAFKA_SOCKET_RECEIVE_BUFFER_BYTES="102400" \
    KAFKA_SOCKET_REQUEST_MAX_BYTES="104857600" \
    KAFKA_NUM_PARTITIONS="1" \
    KAFKA_NUM_RECOVERY_THREADS_PER_DATA_DIR="1" \
    KAFKA_OFFSETS_TOPIC_REPLICATION_FACTOR="1" \
    KAFKA_TRANSACTION_STATE_LOG_REPLICATION_FACTOR="1" \
    KAFKA_TRANSACTION_STATE_LOG_MIN_ISR="1" \
    KAFKA_LOG_RETENTION_HOURS="168" \
    KAFKA_LOG_RETENTION_CHECK_INTERVAL_MS="300000" \
    KAFKA_ZOOKEEPER_CONNECT="localhost:2181" \
    KAFKA_ZOOKEEPER_CONNECTION_TIMEOUT_MS="18000" \
    KAFKA_GROUP_INITIAL_REBALANCE_DELAY_MS="0"

COPY entrypoint /opt/kafka

RUN groupadd -r --gid "$KAFKA_GID" "$KAFKA_GROUP"
RUN useradd -r --uid "$KAFKA_UID" --gid "$KAFKA_GID" "$KAFKA_USER"

RUN apt-get update && \
    apt-get -y install curl && \
    curl -f -L https://downloads.apache.org/kafka/$KAFKA_VERSION/kafka_2.13-$KAFKA_VERSION.tgz --output /tmp/apache-kafka.tar.gz && \
    tar xf /tmp/apache-kafka.tar.gz -C /tmp && \
    mv /tmp/kafka_2.13-$KAFKA_VERSION/libs /opt/kafka/ && \
    mv /tmp/kafka_2.13-$KAFKA_VERSION/bin /opt/kafka/ && \
    mv /tmp/kafka_2.13-$KAFKA_VERSION/config /opt/kafka/ && \
    rm -rf /opt/kafka/bin/windows /tmp/* &&  \
    mkdir -p /opt/kafka/data && \
    chown $KAFKA_USER:$KAFKA_GROUP -R /opt/kafka && \
    chmod +x /opt/kafka/entrypoint && \
    apt-get clean

COPY log4j.properties /opt/kafka/config/log4j.properties

USER $KAFKA_USER
VOLUME ["/opt/kafka/data"]

ENTRYPOINT ["/opt/kafka/entrypoint"]