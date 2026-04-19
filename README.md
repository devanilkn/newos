# newos

An operating system designed to run applications built by AI agents rather than humans.

## What is newos?

newos is a new kind of operating system built from the ground up for a world where software is written by AI. Traditional operating systems were designed around assumptions baked in over decades: that developers are humans who write code deliberately, test it interactively, and reason about failure in familiar ways. newos questions those assumptions.

As AI agents become capable of generating, deploying, and iterating on entire applications autonomously, the substrate they run on needs to evolve. newos is that substrate.

## Core ideas

- **Agent-native execution** — processes and services are first-class outputs of AI agents, not human authors
- **Verifiable behavior** — the OS exposes primitives for asserting and checking what an application does, not just that it runs
- **Safe by default** — isolation, sandboxing, and capability constraints are built into the kernel model, not bolted on
- **Autonomous lifecycle management** — deployment, scaling, and recovery are managed by the system without requiring human intervention
- **Introspectable** — every running application carries a trace of its origin, intent, and generation context

## Status

Early-stage research and development. Nothing here is production-ready.

## Documentation

See the [`docs/`](docs/) directory for design documents and architecture notes.

## License

TBD
