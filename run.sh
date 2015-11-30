#!/bin/bash
set -e
set -x
export DEVPI_SERVERDIR=/mnt
export DEVPI_CLIENTDIR=/tmp/devpi-client
[[ -f $DEVPI_SERVERDIR/.serverversion ]] || initialize=yes

kill_devpi() {
    test -n "$DEVPI_PID" && kill $DEVPI_PID
}
trap kill_devpi EXIT

# For some reason, killing tail during EXIT trap function triggers an
# "uninitialized stack frame" bug in glibc, so kill tail when handling INT or
# TERM signal.
kill_tail() {
    test -n "$TAIL_PID" && kill $TAIL_PID
}
trap kill_tail INT
trap kill_tail TERM

devpi-server --start --host 0.0.0.0 --port 3141 || \
    { [ -f "$LOG_FILE" ] && cat "$LOG_FILE"; exit 1; }
DEVPI_PID="$(cat $DEVPI_SERVERDIR/.xproc/devpi-server/xprocess.PID)"

if [[ $initialize = yes ]]; then
  devpi use http://localhost:3141
  devpi login root --password=''
  devpi user -m root password="${DEVPI_PASSWORD}"
  devpi index -y -c public pypi_whitelist='*'
fi
# We cannot simply execute tail, because otherwise bash won't propagate
# incoming TERM signals to tail and will hang indefinitely.  Instead, we wait
# on tail PID and then "wait" command will interrupt on TERM (or any other)
# signal and the script will proceed to kill_* functions which will gracefully
# terminate child processes.
tail -f /etc/fstab & #"$LOG_FILE" &
TAIL_PID=$!
wait $TAIL_PID
