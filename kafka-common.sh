#!/usr/bin/env bash

source "$(dirname "$0")"/env.sh

function start_kafka_cluster() {
  "$KAFKA_DIR"/bin/kafka-server-start.sh -daemon "$KAFKA_DIR"/config/server.properties
}

function stop_kafka_cluster() {
  if [[ -z $KAFKA_DIR ]]; then
    echo "Must run setup kafka dist dir before attempting to start Kafka cluster"
    exit 1
  fi
  "$KAFKA_DIR"/bin/kafka-server-stop.sh
}

function check_kafka() {
  command=$(jps -l | grep kafka)
  if [[ -z $command ]]; then
    echo "ERROR: kafka server not initiated"
    exit 1
  fi
}

function start_zookeeper() {
  if [[ -z $ZK_DIR ]]; then
    echo "Must run setup kafka dist dir before attempting to start Kafka cluster"
    exit 1
  fi
  "$ZK_DIR"/bin/zkServer.sh start
}

function create_kafka_topic() {
  "$KAFKA_DIR"/bin/kafka-topics.sh --bootstrap-server 192.168.240.155:9092 --create --partitions "$1" --replication-factor "$2" --topic "$3"
}

function drop_kafka_topic() {
  "$KAFKA_DIR"/bin/kafka-topics.sh --bootstrap-server 192.168.240.155:9092 --delete --topic "$1"
}

function send_message() {
  topicName="$1"

  # put JSON data into Kafka
  echo "Sending messages to Kafka..."

  send_messages_to_kafka '{"rowtime": "2018-03-12T08:00:00Z", "user_name": "Alice", "event": { "message_type": "WARNING", "message": "This is a warning."}}' "$topicName"
  send_messages_to_kafka '{"rowtime": "2018-03-12T08:10:00Z", "user_name": "Alice", "event": { "message_type": "WARNING", "message": "This is a warning."}}' "$topicName"
  send_messages_to_kafka '{"rowtime": "2018-03-12T09:00:00Z", "user_name": "Bob", "event": { "message_type": "WARNING", "message": "This is another warning."}}' "$topicName"
  send_messages_to_kafka '{"rowtime": "2018-03-12T09:10:00Z", "user_name": "Alice", "event": { "message_type": "INFO", "message": "This is a info."}}' "$topicName"
  send_messages_to_kafka '{"rowtime": "2018-03-12T09:20:00Z", "user_name": "Steve", "event": { "message_type": "INFO", "message": "This is another info."}}' "$topicName"
  send_messages_to_kafka '{"rowtime": "2018-03-12T09:30:00Z", "user_name": "Steve", "event": { "message_type": "INFO", "message": "This is another info."}}' "$topicName"
  send_messages_to_kafka '{"rowtime": "2018-03-12T09:30:00Z", "user_name": null, "event": { "message_type": "WARNING", "message": "This is a bad message because the user is missing."}}' "$topicName"
  send_messages_to_kafka '{"rowtime": "2018-03-12T10:40:00Z", "user_name": "Bob", "event": { "message_type": "ERROR", "message": "This is an error."}}' "$topicName"
}
