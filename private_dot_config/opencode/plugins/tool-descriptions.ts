// Trim built-in tool descriptions down to load-bearing mechanics only.
//
// The stock descriptions are tuned for the lowest-common-denominator model:
// they re-teach shell quoting, parallel tool calls, when-to-use heuristics,
// and repeat examples. Frontier models already know this. We keep only the
// constraints that prevent real failures (must-read-before-edit, exact
// indentation, line-number prefix format, output-truncated-to-file, etc.)
// and drop the tutoring.
//
// V2 only: `shell` and `subagent` embed runtime text (OS/shell line, agent
// roster) and their stock V2 descriptions are already terse, so they are left
// untouched. Tools missing from the registry are ignored by `editor.update`.

// --- Full replacements (wholly static descriptions) -------------------------

const REPLACE: Record<string, string> = {
	edit: [
		"Exact string replacement in a file.",
		"- Read the file at least once this session first, or the edit errors.",
		"- Match content exactly AFTER the `N: ` line-number prefix from Read output; never include that prefix. Preserve exact indentation.",
		"- Errors if oldString is not found, or is found multiple times (add surrounding context to disambiguate, or use replaceAll).",
		"- replaceAll replaces every occurrence (e.g. renaming a variable).",
	].join("\n"),

	glob: "Fast filename pattern matching (e.g. `**/*.ts`, `src/**/*.tsx`). Returns matching paths. Batch independent globs in parallel.",

	grep: [
		"Fast file-content search over full regex (e.g. `function\\s+\\w+`). Filter files with `include` (e.g. `*.{ts,tsx}`). Returns paths + line numbers + matching lines.",
		"To COUNT matches, shell out to `rg` via bash instead.",
	].join("\n"),

	question: [
		"Ask the user questions mid-execution (preferences, clarification, direction).",
		'- A "Type your own answer" option is auto-added when custom is on; don\'t add "Other".',
		"- Answers return as arrays of labels; set multiple:true to allow several.",
		'- Put a recommended option first, labeled "(Recommended)".',
	].join("\n"),

	read: [
		"Read a file or directory by ABSOLUTE path.",
		"- Returns up to 2000 lines from `offset` (1-indexed); each line is prefixed `N: `. Lines >2000 chars are truncated.",
		"- For large files, use offset/limit or grep rather than tiny repeated slices.",
		"- Reads images and PDFs as attachments. Directories list entries, subdirs trailing `/`.",
	].join("\n"),

	skill: "Load a skill listed in the system prompt (exact name), injecting its instructions and resource references into the conversation.",

	webfetch: [
		"Fetch a URL and return its content as markdown (default), text, or html. Read-only.",
		"- Prefer a more targeted fetch tool if one is available. URL must be fully-formed; http upgrades to https. Large content may be summarized.",
	].join("\n"),

	write: [
		"Write a file (overwrites any existing file).",
		"- To overwrite an existing file you must Read it first.",
		"- Don't create *.md/README docs unless asked.",
	].join("\n"),
};

export default {
	id: "tool-descriptions",
	async setup(ctx: {
		tool: {
			transform(
				cb: (editor: { update(name: string, fn: (tool: { description: string }) => void): void }) => void,
			): Promise<unknown>;
		};
	}) {
		await ctx.tool.transform((editor) => {
			for (const [name, description] of Object.entries(REPLACE)) {
				editor.update(name, (tool) => {
					tool.description = description;
				});
			}
		});
	},
};
