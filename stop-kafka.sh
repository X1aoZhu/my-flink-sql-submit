#!/usr/bin/env bash

source "$(dirname "$0")"/kafka-common.sh

echo "stop kafka cluster"

stop_kafka_cluster
