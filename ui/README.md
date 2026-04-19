# ui

The initial newos user interface.

This is the primary interaction surface for AI agents operating on the system.
It is not designed for human interactive use — it exposes a structured protocol
that agents can use to deploy, inspect, and manage applications.

Responsible for:
- Accepting agent commands over a defined protocol
- Reporting system state in a machine-readable format
- Bridging agent intent to kernel primitives

## Structure

```
ui/
├── src/        # ui source
└── tests/      # ui tests
```

## Status

Stub. Not yet implemented.
