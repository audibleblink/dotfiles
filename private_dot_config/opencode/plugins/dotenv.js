// Matches a .env / .env.* path token (e.g. .env, .env.local, ./config/.env.prod)
// but NOT .envrc or arbitrary words like "environment".
const ENV_FILE = /(^|[\s=:'"/])(\.env)(\.[\w.-]+)?($|[\s'"])/

// Commands that would expose file contents.
const READERS = /\b(cat|bat|less|more|head|tail|nl|tac|od|xxd|hexdump|strings|grep|egrep|fgrep|rg|ag|ack|awk|sed|cut|sort|uniq|wc|source|cp|mv|scp|rsync|dd|tee|xargs|open)\b/

export const EnvProtection = async ({ client, $ }) => {
  return {
    "tool.execute.before": async (input, output) => {
      if (input.tool === "read" && output.args.filePath?.includes(".env")) {
        throw new Error("Do not read .env files")
      }
      if (input.tool === "bash") {
        const cmd = output.args.command ?? ""
        if (ENV_FILE.test(cmd) && (READERS.test(cmd) || /(^|[\s;&|])\.\s+\S*\.env/.test(cmd))) {
          throw new Error("Do not read .env files")
        }
      }
    },
  }
}
