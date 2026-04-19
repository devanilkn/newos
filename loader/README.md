# loader

The newos bootloader.

Responsible for:
- Running after firmware (UEFI/BIOS) hands off control
- Setting up the initial memory map
- Loading the kernel image into memory
- Transferring execution to the kernel entry point

## Structure

```
loader/
├── src/        # loader source
└── tests/      # loader tests
```

## Status

Stub. Not yet implemented.
