#!/usr/bin/env bash
# Validates that the ISO was built and contains the expected files.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ISO="$SCRIPT_DIR/../newos.iso"

fail() { echo "FAIL: $*" >&2; exit 1; }
pass() { echo "PASS: $*"; }

[ -f "$ISO" ] || fail "ISO not found at $ISO"

SIZE=$(stat -c%s "$ISO" 2>/dev/null || stat -f%z "$ISO")
[ "$SIZE" -gt 0 ] || fail "ISO is empty"
pass "ISO exists ($SIZE bytes)"

# Check ISO magic bytes (ISO 9660 magic at offset 32769)
MAGIC=$(dd if="$ISO" bs=1 skip=32769 count=5 2>/dev/null)
[ "$MAGIC" = "CD001" ] || fail "ISO does not have ISO 9660 magic ('$MAGIC')"
pass "ISO 9660 magic bytes present"

# Check that the kernel ELF is extractable from the ISO
if command -v isoinfo &>/dev/null; then
    isoinfo -i "$ISO" -l 2>/dev/null | grep -q "KERNEL.ELF" \
        && pass "kernel.elf found in ISO" \
        || fail "kernel.elf not found in ISO listing"
else
    pass "isoinfo not available — skipping file listing check"
fi
