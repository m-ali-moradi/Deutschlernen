---
name: generate-accurate-vocabularies
description: "Generate accurate vocabulary JSON entries for the deutschmate app."
argument-hint: "Describe the topic, level, entry count, and any constraints"
agent: agent
---
Related skill: `agent-customization`. Load and follow prompts.md for template and principles.

Generate or refine vocabulary content for the deutschmate app.

Use the current file, selected JSON content, and the user's request to determine the target level, category, group, tag, and entry count.

Follow these rules:
- Match the existing JSON schema exactly.
- Keep the field order consistent with nearby entries.
- Use the existing id pattern and continue the sequence from the last item in the file.
- Keep `category`, `group`, and `tag` aligned with the repo's vocabulary taxonomy.
- Use accurate, natural German words or phrases for the requested topic.
- Keep English meanings concise and precise.
- Provide short, simple example sentences that use the target word naturally.
- Set `difficulty` to the appropriate level for the file, and keep it consistent within the batch.
- Keep `isFavorite` false unless the user explicitly asks otherwise.
- Provide a concise, accurate `dari` translation for each entry.
- Do not add a `level` field unless the target file already uses one.
- Avoid duplicates with existing entries or closely related vocabulary files.
- Prefer high-frequency, beginner-friendly vocabulary when the level is A1.

When the request is incomplete, ask only for the minimum missing details:
- target level
- topic or category
- number of entries
- whether the file should contain single words, phrases, or both

Return JSON only when the user asks for content generation. If the request is ambiguous, ask a focused clarification question instead of guessing.
