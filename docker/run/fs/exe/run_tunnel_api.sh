#!/bin/bash

# Wait until run_tunnel.py exists
echo "Starting tunnel API..."

sleep 1
while [ ! -f /a0/run_tunnel.py ]; do
    echo "Waiting for /a0/run_tunnel.py to be available..."
    sleep 1
done

. "/ins/setup_venv.sh" "$@"

exec python /a0/run_tunnel.py \
    --dockerized=true \
    --port="${A0_SET_PORT:-8000}" \
    --tunnel_api_port=55520 \
    --host="0.0.0.0" \
    --code_exec_docker_enabled=false \
    --code_exec_ssh_enabled=true
