#! /usr/bin/env bash

set -eo pipefail

cat <<EOF > ~/.config/git/instead
[url "ssh://git@github.com/"]
	insteadOf = https://github.com/
[url "git@github.com:"]
	insteadOf = https://github.com
EOF
