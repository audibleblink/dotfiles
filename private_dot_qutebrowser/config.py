# vim: foldmarker={{{,}}} foldlevel=0 foldmethod=marker

# Boilerplate / Imports {{{
import catppuccin
from qutebrowser.config.config import ConfigContainer  # noqa: F401
from qutebrowser.config.configfiles import ConfigAPI  # noqa: F401

config: ConfigAPI = config  # noqa: F821 pylint: disable=E0602,C0103
c: ConfigContainer = c  # noqa: F821 pylint: disable=E0602,C0103
# }}}

# UX / UI {{{

catppuccin.setup(c, "mocha")

c.aliases = {
    "q": "quit",
    "w": "session-save",
    "wq": "quit --save",
}

c.url.searchengines = {
    "DEFAULT": "https://duckduckgo.com/?q=g!+{}",
    "git": "https://github.com/search?q={}",
}

c.content.proxy = "system"
c.downloads.position = "bottom"
c.editor.command = ["open", "-na", "ghostty.app", "--args", "-e", "nvim", "{file}"]
c.scrolling.smooth = True
c.confirm_quit = ["multiple-tabs"]
c.auto_save.session = True
c.zoom.default = "125%"
# }}}

## Bindings {{{
config.bind("K", "tab-prev")
config.bind("J", "tab-next")
config.bind("x", "tab-close")
config.bind("X", "undo")
config.bind("ge", "open-editor")
config.bind("gs", "set tabs.show always")
config.bind("gS", "set tabs.show never")
## }}}

## Tabs {{{
c.tabs.last_close = "close"
c.tabs.padding = {"bottom": 10, "left": 10, "right": 10, "top": 10}
c.tabs.position = "left"
c.tabs.show = "always"
c.tabs.show_switching_delay = 2000
c.tabs.title.format = "{host}"
c.tabs.title.format_pinned = "{index}"
c.tabs.width = "10%"
c.tabs.indicator.width = 0
c.tabs.indicator.padding = {"top": 1, "bottom": 1, "left": 0, "right": 10}
c.tabs.wrap = True
## }}}

config.load_autoconfig(False)

## TODO review https://github.com/biohackerellie/.dotfiles/blob/7aaa1de7ec500db092eb9f7105467f111bed7219/config/.config/qutebrowser/config.py
