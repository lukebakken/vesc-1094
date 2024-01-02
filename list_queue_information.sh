#!/bin/sh

set -eu
# set -x

readonly rabbitmqctl_cmd="${RABBITMQCTL_PATH:-rabbitmqctl}"
readonly rabbitmq_node="${1:-rabbit}"
readonly rabbitmq_queue_node_1="${2:-$(hostname)}"
readonly rabbitmq_queue_node_2="${3:-$(hostname)}"

for VHOST in $("$rabbitmqctl_cmd" -n "$rabbitmq_node" list_vhosts --silent < /dev/null)
do
    echo '--------------------------------------------------------------------------------'
    echo "VHOST: $VHOST"
    set +e
    "$rabbitmqctl_cmd" -n "$rabbitmq_node" -p "$VHOST" list_queues name members < /dev/null | grep -E "$rabbitmq_queue_node_1|$rabbitmq_queue_node_2"
    set -e
    echo
done
