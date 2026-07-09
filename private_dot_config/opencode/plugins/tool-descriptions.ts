import type { Plugin } from "@opencode-ai/plugin";

// Trim built-in tool descriptions down to load-bearing mechanics only.
//
// The stock descriptions are tuned for the lowest-common-denominator model:
// they re-teach shell quoting, parallel tool calls, when-to-use heuristics,
// and repeat examples. Frontier models already know this. We keep only the
// constraints that prevent real failures (must-read-before-edit, exact
// indentation, line-number prefix format, output-truncated-to-file, etc.)
// and drop the tutoring.
//
// Two tools embed RUNTIME-generated text and must NOT be clobbered wholesale:
//   - bash: injects the live OS/shell line and a session temp-dir path.
//   - task: injects the available-subagent roster.
// For those we replace only the known-static boilerplate via marker splits
// and preserve whatever opencode generated. If a marker is missing (e.g. an
// opencode update rewrote the boilerplate) we leave the original text intact
// (safe fallback) AND log a warning on every request (loud) so the drift is
// obvious and you know to re-tune the markers.

function warn(tool: string, detail: string): void {
	console.warn(
		`[tool-descriptions] ${tool}: marker not found (${detail}); ` +
			`left original description untouched. Re-tune the plugin.`,
	);
}

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
		"- A \"Type your own answer\" option is auto-added when custom is on; don't add \"Other\".",
		"- Answers return as arrays of labels; set multiple:true to allow several.",
		"- Put a recommended option first, labeled \"(Recommended)\".",
	].join("\n"),

	read: [
		"Read a file or directory by ABSOLUTE path.",
		"- Returns up to 2000 lines from `offset` (1-indexed); each line is prefixed `N: `. Lines >2000 chars are truncated.",
		"- For large files, use offset/limit or grep rather than tiny repeated slices.",
		"- Reads images and PDFs as attachments. Directories list entries, subdirs trailing `/`.",
	].join("\n"),

	skill: "Load a skill listed in the system prompt (exact name), injecting its instructions and resource references into the conversation.",

	todowrite: [
		"Maintain a structured task list for the session.",
		"- Use for multi-step (3+) or non-trivial work; skip for single/trivial/informational requests.",
		"- States: pending, in_progress (exactly one at a time), completed, cancelled.",
		"- Update in real time; mark completed only after the work (incl. verification) is actually done. If blocked, keep in_progress and add a follow-up todo.",
	].join("\n"),

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

// --- Boilerplate stripping for descriptions with runtime content -----------

// bash: everything from this marker to the "# Git and GitHub" section is
// static tutoring. Keep the runtime header (OS/shell + temp-dir) above it and
// the Git section below it.
const BASH_TUTORIAL_START = "IMPORTANT: This tool is for terminal operations";
const BASH_GIT_MARKER = "# Git and GitHub";
const BASH_REPLACEMENT = [
	"For real shell commands (git, npm, docker, build/test runners).",
	"- Prefer dedicated tools over shelling out: glob (not find/ls), grep (not grep/rg), read (not cat/head/tail), edit (not sed/awk), write (not echo/heredoc). Output text directly instead of echo.",
	"- Run in the cwd; use `workdir` to change directory instead of `cd ... &&`.",
	"- Output over 2000 lines / 50KB is truncated and the full result written to a file; read/grep that file rather than piping through head/tail.",
	"- Batch independent commands as parallel tool calls; chain dependent ones with `&&` in one call. Quote paths with spaces.",
	"",
].join("\n");

// task: the preamble + numbered usage notes are static; the
// "Available agent types" roster is runtime-generated and must survive.
const TASK_ROSTER_MARKER = "Available agent types";
const TASK_REPLACEMENT = [
	"Launch a subagent to handle a complex, multi-step task autonomously. Requires subagent_type.",
	"- Don't use for reading a known path (read/glob) or a targeted code search (grep) — those are faster directly.",
	"- Batch independent subagents in parallel. Don't redo work you delegated. A subagent's result is not shown to the user, so summarize it yourself.",
	"- Each run starts fresh unless you pass task_id to resume; give a fresh run a self-contained brief and state whether it should write code or only research, plus how to verify.",
	"",
].join("\n");

export default (async () => {
	return {
		"tool.definition": async (input, output) => {
			const id = input.toolID;

			if (id in REPLACE) {
				output.description = REPLACE[id];
				return;
			}

			if (id === "bash") {
				const d = output.description;
				const start = d.indexOf(BASH_TUTORIAL_START);
				const git = d.indexOf(BASH_GIT_MARKER);
				if (start !== -1 && git !== -1 && git > start) {
					output.description =
						d.slice(0, start) + BASH_REPLACEMENT + d.slice(git);
				} else {
					warn("bash", `start=${start} git=${git}`);
				}
				return;
			}

			if (id === "task") {
				const d = output.description;
				const roster = d.indexOf(TASK_ROSTER_MARKER);
				if (roster !== -1) {
					output.description = TASK_REPLACEMENT + d.slice(roster);
				} else {
					warn("task", `roster marker "${TASK_ROSTER_MARKER}"`);
				}
				return;
			}
		},
	};
}) satisfies Plugin;
