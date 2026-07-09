import type { Plugin } from "@opencode-ai/plugin";

// Skills whose <skill> entry stays in the system prompt's <available_skills>
// block. Every other skill is stripped from the prompt but remains fully
// loadable on demand via the `skill` tool (this hook only rewrites prompt
// text; it does not touch skill availability or permissions).
//
// Names must match the skill's <name> exactly.
const ALLOWLIST = new Set<string>([
	"systematic-debugging",
	"verification-before-completion",
	"customize-opencode",
	"exa-search",
	"browser-use",
	"context7",
]);

const SKILL_BLOCK = /<skill>[\s\S]*?<\/skill>/g;
const NAME = /<name>([^<]+)<\/name>/;

export default (async () => {
	return {
		"experimental.chat.system.transform": async (
			_input,
			output,
		) => {
			// Mutate the array in place. opencode reads the original
			// array reference after this hook returns, so reassigning
			// output.system would be silently discarded.
			for (let i = 0; i < output.system.length; i++) {
				const entry = output.system[i];
				if (!entry.includes("<available_skills>")) {
					continue;
				}

				const kept = (entry.match(SKILL_BLOCK) ?? [])
					.filter((block) => {
						const name = block.match(NAME)
							?.[1]?.trim();
						return name !== undefined &&
							ALLOWLIST.has(name);
					});

				output.system[i] = entry.replace(
					/<available_skills>[\s\S]*<\/available_skills>/,
					`<available_skills>\n${
						kept.join("\n")
					}\n</available_skills>`,
				);
			}
		},
	};
}) satisfies Plugin;
