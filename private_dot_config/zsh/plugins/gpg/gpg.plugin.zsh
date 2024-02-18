#!/usr/bin/env zsh

## Set SSH to use gpg-agent
unset SSH_AGENT_PID

gpg_path=~/.gnupg/run

# gpg_path = "/run/user/$(id -u)/gnupg"
export SSH_AUTH_SOCK="${gpg_path}/S.gpg-agent.ssh"

if [[ ! -d "${gpg_path}"  ]]
then
  mkdir -p "${gpg_path}"
  chmod 700 "${gpg_path}"
fi

# Start the gpg-agent if not already running
if ! pgrep -x -u "${USER}" gpg-agent >/dev/null 2>&1; then
  echo 'starting gpg agent for the first time'
  eval $(gpg-agent --daemon --options ~/.gnupg/gpg-agent.conf)
fi

# Set GPG TTY
export GPG_TTY=$(tty)

# Refresh gpg-agent tty in case user switches into an X session
gpg-connect-agent updatestartuptty /bye >/dev/null
