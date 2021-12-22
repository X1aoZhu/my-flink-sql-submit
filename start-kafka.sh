#!/usr/bin/env bash

source "$(dirname "$0")"/kafka-common.sh

echo "start zookeeper cluster"
start_zookeeper

echo "start kafka cluster"
start_kafka_cluster