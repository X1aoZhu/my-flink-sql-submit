#!/usr/bin/env bash

source "$(dirname "$0")"/kafka-common.sh

check_kafka

echo "create kafka topic"

drop_kafka_topic "$1"