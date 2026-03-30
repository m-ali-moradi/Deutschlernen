---
name: separate-practice-features
description: "Refactor the app into a unified Practice entry point with separate feature modules for Exercises and Exams."
argument-hint: "Describe the feature split, navigation updates, and any constraints"
agent: agent
---
Related skill: `agent-customization`. Load and follow prompts.md for template and principles.

Refactor the app structure to keep the existing Exercises flow intact while introducing a separate Exams feature and a unified Practice entry point.

Use the current workspace context, selected files, and the user's request to determine the app structure, navigation entry points, and state-management boundaries.

Follow these rules:
- Keep the existing `features/exercises/` module unchanged unless a direct navigation or import update is required.
- Create or extend a `features/exams/` module with presentation, domain, and data layers that mirror the app's existing feature architecture.
- Add a Practice screen that acts as the container or entry point for both flows.
- Update bottom navigation, routes, and any deep links so the user enters Practice first.
- In Practice, present clear sections or cards for Exercises and Exams, each navigating to its own flow.
- Keep Riverpod state separate for Exercises and Exams.
- Reuse the repo's existing conventions for naming, layering, and folder placement.
- Minimize unrelated changes; do not restructure features outside the requested scope.

When the request is incomplete, ask only for the minimum missing details:
- Which screen or route should become the Practice entry point
- Whether the new Exams module should reuse any shared UI or remain fully isolated
- Any constraints on route names or folder naming

If the request is clear, implement the refactor directly and summarize the changed files and navigation impact briefly.