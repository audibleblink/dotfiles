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
	"msgraph",
	"context7",
]);

const SKILL_BLOCK = /<skill>[\s\S]*?<\/skill>/g;
const NAME = /<name>([^<]+)<\/name>/;

type SystemPart = { type: string; text?: string };

export default {
	id: "skill-prompt-allowlist",
	async setup(ctx: {
		session: { hook(name: "context", cb: (e: { system: SystemPart[] }) => void): Promise<unknown> };
	}) {
		await ctx.session.hook("context", (event) => {
			for (let i = 0; i < event.system.length; i++) {
				const entry = event.system[i];
				if (!entry.text?.includes("<available_skills>")) continue;

				const kept = (entry.text.match(SKILL_BLOCK) ?? []).filter((block) => {
					const name = block.match(NAME)?.[1]?.trim();
					return name !== undefined && ALLOWLIST.has(name);
				});

				event.system[i] = {
					...entry,
					text: entry.text.replace(
						/<available_skills>[\s\S]*<\/available_skills>/,
						`<available_skills>\n${kept.join("\n")}\n</available_skills>`,
					),
				};
			}
		});
	},
};
