#!/bin/bash
set -e

rake db:create db:migrate
rails assets:precompile
rm -f /myapp/tmp/pids/server.pid

# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"
