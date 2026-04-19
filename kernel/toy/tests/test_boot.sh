#!/usr/bin/env bash
# Boots the ISO in QEMU and checks that the toy kernel prints the expected
# message over the serial port. Requires qemu-system-x86_64 and a built ISO.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"
ISO="$REPO_ROOT/sysmaker/newos.iso"
TIMEOUT=15
EXPECTED="Hello, newos!"

if [ ! -f "$ISO" ]; then
    echo "FAIL: ISO not found at $ISO — run 'make' in sysmaker/ first" >&2
    exit 1
fi

if ! command -v qemu-system-x86_64 &>/dev/null; then
    echo "FAIL: qemu-system-x86_64 not found" >&2
    exit 1
fi

OUTPUT=$(timeout "$TIMEOUT" qemu-system-x86_64 \
    -cdrom "$ISO" \
    -m 32M \
    -display none \
    -serial stdio \
    -no-reboot \
    2>/dev/null || true)

if echo "$OUTPUT" | grep -qF "$EXPECTED"; then
    echo "PASS: kernel printed '$EXPECTED'"
    exit 0
else
    echo "FAIL: expected '$EXPECTED' in serial output" >&2
    echo "--- output ---" >&2
    echo "$OUTPUT" >&2
    exit 1
fi
