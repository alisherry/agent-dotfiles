---
name: summarize-change
description: Summarize a code change, branch, pull request, or patch for reviewers. Use when the user wants intent, behavior, risk, and verification—not a file-by-file inventory.
---

# Summarize Change

Inspect the actual diff and relevant surrounding code before writing the summary.

Lead with the user-visible or architectural outcome. Then cover:

- the problem and intended behavior;
- the substantive implementation choices;
- migrations, compatibility effects, or operational risk;
- tests and checks actually run, with honest results;
- the parts a reviewer should scrutinize.

Group related edits by purpose rather than listing every file. Distinguish observed behavior from inferred intent. Do not claim a check passed unless there is evidence it ran successfully. Call out omitted verification and unrelated changes.
