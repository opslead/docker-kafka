FROM azul/zulu-openjdk:11

LABEL maintainer="opslead"
LABEL repository="https://github.com/opslead/docker-kafka"

ARG KAFKA_VERSION

WORKDIR /opt/kafka

ENV KAFKA_USER="kafka" \
    KAFKA_UID="8983" \
    KAFKA_GROUP="kafka" \
    KAFKA_GID="8983"

RUN groupadd -r --gid "$KAFKA_GID" "$KAFKA_GROUP"
RUN useradd -r --uid "$KAFKA_UID" --gid "$KAFKA_GID" "$KAFKA_USER"

RUN apt-get update && \
    apt-get -y install curl && \
    curl -f -L https://downloads.apache.org/kafka/$KAFKA_VERSION/kafka_2.13-$KAFKA_VERSION.tgz --output /tmp/apache-kafka.tar.gz && \
    tar -C /tmp --extract --file /tmp/apache-kafka.tar.gz && \
    rm /tmp/apache-kafka.tar.gz && \
    mv /tmp/kafka* /tmp/kafka && \
    mv /tmp/kafka/lib /opt/kafka/ && \
    mv /tmp/kafka/bin /opt/kafka/ && \
    mv /tmp/kafka/config /opt/kafka/ && \
    rm -rf /opt/kafka/bin/windows /tmp/* &&  \
    mkdir -p /opt/kafka/data && \
    chown $KAFKA_USER:$KAFKA_GROUP -R /opt/kafka && \
    apt-get clean

COPY entrypoint /opt/kafka
COPY logback.xml /opt/kafka
RUN chmod +x /opt/kafka/entrypoint

USER $KAFKA_USER
VOLUME ["/opt/kafka/data"]

ENTRYPOINT ["/opt/kafka/entrypoint"]