// Matches a .env / .env.* path token (e.g. .env, .env.local, ./config/.env.prod)
// but NOT .envrc or arbitrary words like "environment".
const ENV_FILE = /(^|[\s=:'"/])(\.env)(\.[\w.-]+)?($|[\s'"])/

// Commands that would expose file contents.
const READERS = /\b(cat|bat|less|more|head|tail|nl|tac|od|xxd|hexdump|strings|grep|egrep|fgrep|rg|ag|ack|awk|sed|cut|sort|uniq|wc|source|cp|mv|scp|rsync|dd|tee|xargs|open)\b/

// V2 names the shell tool `shell`; `bash` was its V1 name.
const SHELL_TOOLS = new Set(["shell", "bash"])

export default {
  id: "env-protection",
  async setup(ctx) {
    await ctx.tool.hook("execute.before", (event) => {
      const input = event.input ?? {}
      if (event.tool === "read" && (input.path ?? input.filePath)?.includes(".env")) {
        throw new Error("Do not read .env files")
      }
      if (SHELL_TOOLS.has(event.tool)) {
        const cmd = input.command ?? ""
        if (ENV_FILE.test(cmd) && (READERS.test(cmd) || /(^|[\s;&|])\.\s+\S*\.env/.test(cmd))) {
          throw new Error("Do not read .env files")
        }
      }
    })
  },
}
