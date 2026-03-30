---
name: enhance-exams-official-content
description: "Populate the Exams feature with concise, structured content from official exam providers and traceable resources."
argument-hint: "Describe the exams, levels, sources, and any content constraints"
agent: agent
---
Related skill: `agent-customization`. Load and follow prompts.md for template and principles.

Enhance the Exams feature by sourcing concise, structured exam information from official providers and storing it in a replaceable data format.

Use the current workspace context, selected files, and the user's request to determine the exams that need content, the expected schema, and the integration points in the feature.

Follow these rules:
- Use only reliable official sources for exam facts and resources.
- Prefer official pages from Goethe-Institut, telc, ÖSD, and Deutsche Welle when they provide supporting materials.
- For each exam level requested, populate:
  - structure: modules, duration, and high-level format
  - procedure: flow, timing, and basic scoring overview
  - tips: 3 to 5 short, practical points
- Add official resources with direct links where possible:
  - model test PDFs from official sources only
  - listening audio files in MP3 format from official sources or DW
- Include the source URL for every exam entry and resource so the content remains traceable.
- If no official resource exists, add a placeholder entry labeled "No official material available yet".
- Keep content concise and structured; do not copy long passages from sources.
- Store the data in a replaceable structure such as `ExamInfo` and `Resource`, so future updates can be driven by API or config changes.
- Keep the Exams feature isolated from Exercises unless a shared utility is explicitly required.
- Preserve the repo's existing naming, layering, and state-management conventions.

When the request is incomplete, ask only for the minimum missing details:
- Which exam levels or providers to prioritize first
- Whether the output should be added to JSON, Dart models, or both
- Any preferred source order if multiple official providers cover the same exam

If the request is clear, implement the content update directly and summarize the added sources, placeholders, and affected files briefly.



further addition of information:
1.