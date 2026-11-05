#!/bin/bash
# llama-server for AI completion in nvim (llama.vim). run via launchd: ca.carper.llama-server
# model picked by RAM: Qwen3-Coder-30B-A3B at Q4_K_M is ~17GB of wired GPU memory and
# needs headroom beside docker and everything else (the Q8_0 preset is 30GB and starves a 64GB mac)

set -u

# launchd's PATH lacks homebrew; cover both apple silicon and intel prefixes
PATH=/opt/homebrew/bin:/usr/local/bin:$PATH

mem_gb=$(( $(sysctl -n hw.memsize) / 1073741824 ))
if [ "$mem_gb" -ge 48 ]; then
    # same flags as --fim-qwen-30b-default, with a Q4_K_M quant in place of its Q8_0 file
    exec llama-server -hf unsloth/Qwen3-Coder-30B-A3B-Instruct-GGUF:Q4_K_M \
        --port 8012 -b 1024 -ub 1024 --cache-reuse 256 -c 32768 "$@"
fi

# the preset leaves the context at the model's max; -c after it overrides that
exec llama-server --fim-qwen-7b-default -c 32768 "$@"
