// Dumps the FULL outbound LLM request (system prompt + all tool schemas +
// messages) to disk by wrapping the AI SDK provider's fetch.
//
// Enable with: OPENCODE_CAPTURE=1 opencode --config alt.jsonc
// Output dir:  ~/opencode-capture/  (one JSON per request)

import { mkdirSync, writeFileSync } from "fs"
import { homedir } from "os"
import { join } from "path"

const OUT = join(homedir(), "opencode-capture")

function wrapFetch(baseFetch) {
  const f = baseFetch ?? globalThis.fetch
  return async (input, init) => {
    try {
      const url = typeof input === "string" ? input : input?.url ?? ""
      if (init?.body && /\/(messages|chat\/completions|generateContent)/.test(url)) {
        mkdirSync(OUT, { recursive: true })
        const raw = typeof init.body === "string" ? init.body : Buffer.from(init.body).toString("utf8")
        let payload = raw
        try {
          const parsed = JSON.parse(raw)
          payload = JSON.stringify(
            {
              url,
              model: parsed.model,
              system: parsed.system,
              tools: parsed.tools,
              tool_names: (parsed.tools ?? []).map((t) => t.name ?? t.function?.name),
              messages: parsed.messages,
            },
            null,
            2,
          )
        } catch {}
        const file = join(OUT, `req-${Date.now()}.json`)
        writeFileSync(file, payload)
        console.error(`[capture] wrote ${file}`)
      }
    } catch (e) {
      console.error("[capture] error:", e?.message)
    }
    return f(input, init)
  }
}

export const Capture = async () => {
  if (process.env.OPENCODE_CAPTURE !== "1") return {}
  return {
    // Inject a logging fetch into every custom provider's options before init.
    config: async (config) => {
      for (const prov of Object.values(config.provider ?? {})) {
        prov.options = prov.options ?? {}
        prov.options.fetch = wrapFetch(prov.options.fetch)
      }
    },
  }
}
