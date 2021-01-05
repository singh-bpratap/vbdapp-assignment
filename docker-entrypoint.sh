#!/bin/bash

set -e

# Remove pre-existing server.pid for Rails.
rm -f /app/tmp/pids/server.pid

# Run the command.
exec "$@"
