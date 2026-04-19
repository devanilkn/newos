# newos — Claude instructions

## Design documentation

For any significant work — new components, architectural decisions, protocol definitions, non-obvious implementation choices, or changes that affect multiple components — create a design document before or alongside the code.

Place it in the appropriate subdirectory of `design/`:

- `design/architecture/` — high-level system structure and cross-cutting concerns
- `design/specs/` — detailed specifications for a component or interface
- `design/rfcs/` — proposals for changes that need discussion before implementation
- `design/sessions/` — transcripts and summaries of design sessions

Each design document should include:
- **Status** — `Draft`, `Accepted`, `Superseded`, or `Rejected`
- **Context** — what problem this addresses and why it matters
- **Decision** — what was decided or designed
- **Consequences** — what this makes easier, harder, or different

"Significant work" includes but is not limited to:
- Adding a new component or subsystem
- Defining an interface between components
- Choosing a language, runtime, or dependency
- Any decision that would be hard to reverse later

Small, local changes (fixing a typo, renaming a variable, adding a test) do not need a design document.

## Repository layout

```
newos/
├── kernel/      # OS kernel — scheduling, IPC, capability enforcement
├── loader/      # Bootloader — firmware handoff to kernel
├── sysmaker/    # Image builder — assembles a bootable system
├── ui/          # Initial agent-facing interface
├── docs/        # User and developer documentation
└── design/      # Architecture decisions, specs, and RFCs
```

## Branch naming

- `scaffold/<topic>` — structural or project setup work
- `kernel/<topic>` — kernel changes
- `loader/<topic>` — loader changes
- `sysmaker/<topic>` — sysmaker changes
- `ui/<topic>` — UI changes
- `docs/<topic>` — documentation changes
- `design/<topic>` — design document work
