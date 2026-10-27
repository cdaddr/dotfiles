#!/bin/bash
# keep Audeze Maxwell awake by streaming silence to it whenever it's connected.
# the headset sleeps on silence and clips the start of the next sound; a
# constant (silent) stream prevents that. run via launchd: ca.carper.maxwell-fix

set -u

# launchd's PATH lacks homebrew; cover both apple silicon and intel prefixes
PATH=/opt/homebrew/bin:/usr/local/bin:$PATH
FFMPEG=$(command -v ffmpeg) || { echo "ffmpeg not found" >&2; exit 1; }
# the dongle exposes "Chat-Audeze Maxwell" (x2) and "Game-Audeze Maxwell"; game is the main audio path
PATTERN=${MAXWELL_DEVICE_PATTERN:-Game-Audeze Maxwell}
POLL=${MAXWELL_POLL_SECONDS:-10}

player=

log() { echo "$(date '+%F %T') $*"; }

# print the audiotoolbox index of the first output device matching PATTERN
find_device() {
    "$FFMPEG" -hide_banner -f lavfi -i anullsrc -t 0 \
        -f audiotoolbox -list_devices true - 2>&1 |
        grep -i -- "$PATTERN" |
        sed -n 's/.*\] \[\([0-9]*\)\].*/\1/p' |
        head -n 1
}

stop_player() {
    if [ -n "$player" ]; then
        kill "$player" 2>/dev/null
        wait "$player" 2>/dev/null
        player=
    fi
}

trap 'stop_player; exit 0' TERM INT

current=
while true; do
    index=$(find_device)

    # player exited on its own (e.g. device vanished mid-stream)
    if [ -n "$player" ] && ! kill -0 "$player" 2>/dev/null; then
        wait "$player" 2>/dev/null
        log "player exited"
        player=
    fi

    # device gone, or its index shifted after another device came or went
    if [ -n "$player" ] && [ "$index" != "$current" ]; then
        log "device changed (${current} -> ${index:-none}), stopping"
        stop_player
    fi

    if [ -z "$player" ] && [ -n "$index" ]; then
        log "streaming silence to device $index"
        "$FFMPEG" -hide_banner -nostdin -loglevel error \
            -f lavfi -i anullsrc=channel_layout=stereo:sample_rate=48000 \
            -f audiotoolbox -audio_device_index "$index" - &
        player=$!
        current=$index
    fi

    sleep "$POLL" &
    wait $!
done
