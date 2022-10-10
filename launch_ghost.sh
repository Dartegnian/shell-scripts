#! /usr/bin/env bash

set -x
cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}";)" &> /dev/null && pwd 2> /dev/null;
exec docker-compose -f docker-compose.yml up -d $@
