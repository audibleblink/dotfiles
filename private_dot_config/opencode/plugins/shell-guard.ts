/**
 * shell-guard
 *
 * Hard-blocks bash invocations that should be done via dedicated tools instead:
 *   - file readers (cat/nl/head/tail/less/more/bat) leading a segment → use `read`
 *   - heredoc-to-file (cat <<EOF > file)                              → use `write`
 *   - pip install                                                     → use `uv`
 *
 * Ported from pi-harness/extensions/shell-guard.ts to opencode's
 * `tool.execute.before` hook (throwing blocks the call). Add rules to RULES.
 */

type Rule = {
	name: string;
	test: (cmd: string) => boolean;
	reason: string;
};

const READER_HEAD = /^(?:cat|nl|head|tail|less|more|bat)\b/;

/** True if any shell segment leads with a command matching `head`. */
function leadsSegment(cmd: string, head: RegExp, sep: RegExp): boolean {
	for (const seg of cmd.split(sep)) {
		const trimmed = seg.trim().replace(/^\(+\s*/, "");
		if (head.test(trimmed)) return true;
	}
	return false;
}

const RULES: Rule[] = [
	{
		name: "heredoc-write",
		test: (cmd) => /<<-?\s*['"]?\w+['"]?[\s\S]*?>\s*\S/.test(cmd),
		reason: "Use the `write` tool to create/overwrite files, not `cat <<EOF > file`.",
	},
	{
		name: "file-reader",
		// Flag only when a reader is the LEADING command of a segment, so
		// `... | head` and `git log | cat` remain allowed.
		test: (cmd) => leadsSegment(cmd, READER_HEAD, /&&|\|\||;|\n/),
		reason: "Use the `read` tool for file contents, not bash readers (cat/head/tail/nl/less/more/bat).",
	},
	{
		name: "pip-install",
		test: (cmd) =>
			leadsSegment(cmd, /^(?:python3?\s+-m\s+)?pip3?\s+install\b/, /&&|\|\||;|\n|\|/),
		reason: "Use `uv` (e.g. `uv tool install` for global tools or `uv add` for local deps) instead of `pip install`.",
	},
];

export const ShellGuard = async () => {
	return {
		"tool.execute.before": async (input: { tool: string }, output: { args: { command?: string } }) => {
			if (input.tool !== "bash") return;
			const cmd = output.args?.command ?? "";
			if (!cmd) return;
			for (const rule of RULES) {
				if (rule.test(cmd)) {
					throw new Error(`[shell-guard:${rule.name}] ${rule.reason}`);
				}
			}
		},
	};
};
