#!/bin/bash
# llama-server for AI completion in nvim (llama.vim). run via launchd: ca.carper.llama-server
# model picked by RAM: Qwen3-Coder-30B-A3B is ~32GB at Q8 and needs headroom beside everything else

set -u

# launchd's PATH lacks homebrew; cover both apple silicon and intel prefixes
PATH=/opt/homebrew/bin:/usr/local/bin:$PATH

mem_gb=$(( $(sysctl -n hw.memsize) / 1073741824 ))
if [ "$mem_gb" -ge 48 ]; then
    preset=--fim-qwen-30b-default
else
    preset=--fim-qwen-7b-default
fi

# the presets set port 8012 and leave the context at the model's max (256k for
# qwen3-coder, a huge KV cache); -c after the preset overrides it
exec llama-server "$preset" -c 32768 "$@"
