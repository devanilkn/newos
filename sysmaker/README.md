# sysmaker

The newos system image builder.

Responsible for:
- Assembling the kernel, loader, and UI into a single bootable image
- Configuring boot parameters
- Producing output formats (ISO, disk image, etc.)
- Providing a reproducible, automated build pipeline

## Structure

```
sysmaker/
├── src/        # sysmaker source
├── config/     # default build configurations
└── tests/      # build and output validation tests
```

## Status

Stub. Not yet implemented.
