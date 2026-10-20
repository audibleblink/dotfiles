/**
 * shell-guard
 *
 * Hard-blocks bash invocations that should be done via dedicated tools instead:
 *   - file readers (cat/nl/head/tail/less/more/bat) leading a segment → use `read`
 *   - heredoc-to-file (cat <<EOF > file)                              → use `write`
 *   - pip install                                                     → use `uv`
 *
 * Ported from pi-harness/extensions/shell-guard.ts to opencode's V2
 * `ctx.tool.hook("execute.before")` (throwing blocks the call). Add rules to RULES.
 */

import { readFileSync } from "node:fs";
import { homedir } from "node:os";
import { join } from "node:path";

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

/** Rule names in `disabled` of ~/.config/opencode/shell-guard.json are skipped (read once at init). */
function loadDisabled(): Set<string> {
	try {
		const d = JSON.parse(readFileSync(join(homedir(), ".config/opencode/shell-guard.json"), "utf8")).disabled;
		return new Set(Array.isArray(d) ? d.filter((x) => typeof x === "string") : []);
	} catch {
		return new Set();
	}
}

// V2 names the shell tool `shell`; `bash` was its V1 name.
const SHELL_TOOLS = new Set(["shell", "bash"]);

export default {
	id: "shell-guard",
	async setup(ctx: {
		tool: { hook(name: "execute.before", cb: (e: { tool: string; input: unknown }) => void): Promise<unknown> };
	}) {
		const disabled = loadDisabled();
		const active = RULES.filter((r) => !disabled.has(r.name));
		await ctx.tool.hook("execute.before", (event) => {
			if (!SHELL_TOOLS.has(event.tool)) return;
			const cmd = (event.input as { command?: string })?.command ?? "";
			if (!cmd) return;
			for (const rule of active) {
				if (rule.test(cmd)) {
					throw new Error(`[shell-guard:${rule.name}] ${rule.reason}`);
				}
			}
		});
	},
};
