# Project Overview

## Motivation

Software development is changing. AI agents can now write, test, and deploy code faster than any human team — but the systems they target were not designed for them. POSIX, Linux, and the broader Unix tradition assume a human in the loop: someone who reads error messages, debugs interactively, and makes judgment calls. That assumption is breaking down.

newos is an attempt to design an operating system without that assumption.

## Design goals

### 1. Agent-native process model

Applications deployed on newos are expected to be generated, not handwritten. The process model reflects this: every running application carries metadata about its origin — which agent generated it, what prompt or goal drove it, and what version of its specification it satisfies. This isn't logging; it's a first-class property of a running process.

### 2. Capability-based isolation

AI-generated code is harder to audit by inspection. newos enforces strict capability constraints at the kernel level: an application must explicitly declare what resources it can access, and the OS enforces those declarations. An application that tries to open a network socket it didn't declare access to is denied, not just warned about.

### 3. Behavioral contracts

Beyond resource access, newos introduces the concept of behavioral contracts — machine-checkable descriptions of what an application is supposed to do. The OS can evaluate whether a running application is conforming to its contract and take action (pause, restart, escalate) if it drifts.

### 4. Autonomous lifecycle

In a world where agents write software, agents should also operate it. newos provides lifecycle primitives (deploy, scale, recover, retire) that are designed to be driven programmatically by agents rather than by human operators following runbooks.

### 5. Minimal trust in generated code

The system treats all agent-generated code as untrusted by default. Trust is earned through a combination of behavioral conformance, capability restriction, and optional formal verification passes.

## Non-goals

- Compatibility with existing POSIX applications is not a goal
- General-purpose interactive computing (shell use, IDEs, graphical desktops) is out of scope
- This is not a container runtime or a hypervisor, though it may use those as primitives

## Architecture (sketch)

```
┌─────────────────────────────────────────┐
│              Agent plane                │  ← AI agents deploy & manage apps
├─────────────────────────────────────────┤
│          Application runtime            │  ← sandboxed execution of agent-generated apps
├─────────────────────────────────────────┤
│      Behavioral contract engine         │  ← checks conformance at runtime
├─────────────────────────────────────────┤
│    Capability & resource scheduler      │  ← enforces declared access only
├─────────────────────────────────────────┤
│            newos kernel                 │  ← process model, IPC, storage
└─────────────────────────────────────────┘
```

## Open questions

- How should behavioral contracts be specified? Formal logic, probabilistic assertions, or something else?
- What is the right trust model when one agent generates code that another agent will run?
- How do we handle the case where agent-generated code is subtly wrong in ways behavioral contracts don't catch?
- What does "debugging" look like when there is no human developer?
