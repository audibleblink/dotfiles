# vim: foldmarker={{{,}}} foldlevel=0 foldmethod=marker

# Boilerplate / Imports {{{
from qutebrowser.config.config import ConfigContainer  # noqa: F401
from qutebrowser.config.configfiles import ConfigAPI  # noqa: F401

import catppuccin

config: ConfigAPI = config  # noqa: F821 pylint: disable=E0602,C0103
c: ConfigContainer = c  # noqa: F821 pylint: disable=E0602,C0103
# }}}

leader = " "

# Browser Behavior {{{
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
c.editor.command = [
    "open",
    "-na",
    "ghostty.app",
    "--args",
    "-e",
    "zsh",
    "-c",
    "nvim {file}",
]
c.scrolling.smooth = True
c.confirm_quit = ["multiple-tabs"]
c.auto_save.session = True

# Auto-load insert mode on text fields - automatically enter insert mode when clicking on input fields
c.input.insert_mode.auto_load = True
c.completion.height = "33%"
c.content.pdfjs = True
c.content.autoplay = False
# Allow websites to read canvas data (needed for some web apps but potential fingerprinting vector)
c.content.canvas_reading = True
# Enable WebGL (required for 3D graphics, may be disabled for privacy/security)
c.content.webgl = True
# }}}

# UX / UI {{{
catppuccin.setup(c, "macchiato")

c.zoom.default = "125%"
c.fonts.default_size = "14pt"
c.fonts.default_family = "Codelia Ligatures"

# Dark mode settings - prefer dark color scheme when supported by websites
config.set("colors.webpage.darkmode.enabled", True)
config.set("colors.webpage.preferred_color_scheme", "auto")

## Tabs {{{
c.tabs.last_close = "close"
c.tabs.padding = {"bottom": 10, "left": 10, "right": 10, "top": 10}
c.tabs.position = "left"
c.tabs.show = "always"
c.tabs.show_switching_delay = 2000
c.tabs.title.format = "{host}"
c.tabs.title.format_pinned = "{index}"
c.tabs.width = "15%"
c.tabs.indicator.width = 0
c.tabs.indicator.padding = {"top": 1, "bottom": 1, "left": 0, "right": 10}
c.tabs.wrap = True
c.tabs.background = False  # open new tabs in background by default

## }}}
# }}}

## Bindings {{{

## Navigation Bindings {{{
config.bind("H", "back")
config.bind("L", "forward")
config.bind("K", "tab-prev")
config.bind("J", "tab-next")
config.bind("x", "tab-close")
config.bind("X", "undo")
config.bind("ge", "open-editor")
config.bind("gs", "config-cycle tabs.show multiple never")

# UI Nav
config.bind("<Ctrl-n>", "completion-item-focus next", mode="command")
config.bind("<Ctrl-p>", "completion-item-focus prev-page", mode="command")
# }}}

## Opening & Tab Management {{{
config.bind("t", "cmd-set-text -s :open -t")  # Open in new tab
config.bind("O", "cmd-set-text -s :open -w")  # Open in new window
config.bind("P", "cmd-set-text -s :open -p")  # Open in private window
config.bind("W", "tab-clone -w")  # Clone current tab in new window
# }}}

## Leader-based Commands {{{
config.bind(leader + "<tab>", "tab-focus last")

# Toggle statusbar
config.bind(leader + "b", "config-cycle statusbar.show always in-mode")

config.bind(leader + "p", "tab-pin")

# Configuration
config.bind(leader + "c", "config-edit")  # Edit config.py in editor

# Developer tools
config.bind(leader + "d", "devtools")  # Toggle dev tools
config.bind(leader + "D", "devtools-focus")  # Focus dev tools or page

# Editor & command line
config.bind(leader + "e", "edit-text")  # Edit form field in external editor
config.bind(leader + "E", "cmd-edit")  # Edit current command in external editor

# Hints & help
config.bind(leader + "i", "hint inputs")  # Hint only input fields
config.bind(leader + "h", "history")  # Show browsing history
config.bind(leader + "H", "help")  # Show help

# Bookmarks
config.bind(leader + "m", "bookmark-list")  # List all bookmarks
config.bind(leader + "M", "bookmark-add")  # Add current page to bookmarks

# Tab cloning & management
config.bind(leader + "n", "tab-clone")  # Clone tab in same window
config.bind(leader + "N", "tab-clone -w")  # Clone tab in new window
config.bind(leader + "o", "hint links window")  # Hint and open link in new window
config.bind(
    leader + "O", "hint links run :open -p {hint-url}"
)  # Hint and open in private window

# Pin & positioning
config.bind(leader + "p", "tab-pin")  # Pin current tab
config.bind(leader + "P", "cmd-set-text -s :tab-move")  # Move tab to position

# Reload & restart
config.bind(leader + "r", "config-source")  # Reload config
config.bind(leader + "R", "restart")  # Restart qutebrowser

# Screenshot
config.bind(leader + "s", "screenshot")  # Take screenshot

# Source viewing
config.bind(leader + "S", "view-source --edit")  # View source in editor

# Tab selection
config.bind(leader + "t", "cmd-set-text -s :tab-select")  # Select tab by name/index
config.bind(leader + "T", "tab-only")  # Close all other tabs

# Undo & video
config.bind(leader + "u", "undo")  # Reopen closed tab
config.bind(leader + "v", "hint links spawn mpv {hint-url}")  # Play hinted video in mpv

# Tab give/take (move tabs between windows)
config.bind(leader + "w", "cmd-set-text -s :tab-take")  # Take tab from another window
config.bind(leader + "W", "tab-give")  # Give tab to another window

config.bind(leader + "y", "hint links yank")  # Yank (copy) hinted link
# }}}

## Media Commands {{{
# Video playback with mpv
config.bind(
    ";w", "hint links spawn --detach mpv --force-window yes {hint-url}"
)  # Play hinted video
config.bind(";W", "spawn --detach mpv --force-window yes {url}")  # Play current page

# Image downloads
# config.bind(";I", "hint images spawn --output-message wget -P ~/Pictures/images/ -c {hint-url}")
# }}}

## Zoom bindings {{{
# Alternative zoom bindings using Ctrl
config.bind("<Ctrl-=>", "zoom-in")
config.bind("<Ctrl-->", "zoom-out")
# }}}

## }}}

config.load_autoconfig(False)
