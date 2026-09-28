---
name: strict-code-review
description: Perform a findings-first code review focused on correctness, security, regressions, and maintainability. Use when the user explicitly asks for a review, audit, deep review, or strict review.
---

# Strict Code Review

Review the diff and enough surrounding code to understand its contracts. Do not edit files unless the user also asks for fixes.

Prioritize findings that can change behavior:

1. correctness and data integrity;
2. security, privacy, and trust boundaries;
3. concurrency, lifecycle, and failure handling;
4. compatibility and regressions;
5. missing high-value tests;
6. maintainability issues with a concrete cost.

For each finding, state the severity, cite the smallest useful file and line location, explain the failure mode, and suggest a direction for repair. Avoid speculative warnings without a plausible trigger. Separate blockers from non-blocking suggestions.

Put findings first, ordered by severity. Follow with assumptions or open questions, then a short change summary. If no material findings exist, say so and name any residual verification gap.
