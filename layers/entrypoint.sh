#!/usr/bin/env bash
set -euo pipefail

_term() {
  >&2 echo "TERM (entrypoint.sh)"
  exit 0
}
trap "_term" TERM

echo "{\"<$CHISEL_USER:$CHISEL_PASS>\": [\"\"]}" > /root/users.json

while true; do
  set +e
    chisel server -v --authfile /root/users.json --port $PORT --reverse
    # chisel server --port $PORT --reverse
  set -e
  sleep 1
done

done