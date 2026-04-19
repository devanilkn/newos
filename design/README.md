# design

System design documentation for newos.

This is where architectural decisions, specifications, and RFCs live. Documents
here describe *how* the system works and *why* it is designed the way it is.
They are the authoritative source of truth for implementors.

## Structure

```
design/
├── architecture/   # high-level system architecture documents
├── specs/          # detailed component specifications
└── rfcs/           # proposals for significant changes or additions
```

## Conventions

- Each document should state its status: `Draft`, `Accepted`, `Superseded`, or `Rejected`
- RFCs that are accepted move their conclusions into `specs/`
- Superseded documents are kept for historical context with a note pointing to the replacement
