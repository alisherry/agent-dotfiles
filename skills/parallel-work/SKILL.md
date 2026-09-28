---
name: parallel-work
description: Coordinate multiple agents or independent work lanes safely. Use when the user asks to delegate, parallelize, spawn subagents, split a task, or run concurrent implementation and review.
---

# Parallel Work

Use parallelism only for genuinely independent work. Preserve a single owner for every mutable path and decision.

1. Split the request into deliverables with explicit inputs, outputs, and boundaries.
2. Identify dependencies before dispatch. Keep dependent work sequential.
3. Give each lane the context needed to finish without guessing, including constraints and verification.
4. Isolate concurrent write lanes with branches or worktrees when available. Never assign two writers to the same file set.
5. Keep integration ownership in one lane. Review each result, resolve conflicts deliberately, and run end-to-end verification after assembly.
6. Record unfinished work and blockers in durable project state rather than relying on agent memory.

If agent delegation is unavailable, execute the same plan sequentially. Do not broaden permissions, deployment authority, or data access merely because work was delegated.
