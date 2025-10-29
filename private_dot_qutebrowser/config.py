import catppuccin

config.load_autoconfig(False)
c.aliases = {
    "pocket": "open -t https://getpocket.com/edit?url={url}",
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

## Bindings {{{
config.bind("K", "tab-prev")
config.bind("J", "tab-next")
config.bind("X", "undo")
config.bind("d", "scroll-page 0 0.5")
config.bind("ge", "open-editor")
config.bind("sp", "pocket")
config.bind("u", "scroll-page 0 -0.5")
config.bind("x", "tab-close")
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

## Colors {{{
catppuccin.setup(c, "mocha")
# c.colors.completion.odd.bg = "#2d2d2d"
# c.colors.completion.even.bg = "#282828"
# c.colors.completion.category.fg = "#6699cc"
# c.colors.completion.category.bg = (
#     "qlineargradient(x1:0, y1:0, x2:0, y2:1, stop:0 #282828, stop:1 #1d2021)"
# )
# c.colors.completion.category.border.top = "black"
# c.colors.completion.item.selected.fg = "#1d2021"
# c.colors.completion.item.selected.bg = "#f99157"
# c.colors.completion.item.selected.border.top = "#bbbb00"
# c.colors.completion.match.fg = "#f99157"
# c.colors.completion.scrollbar.fg = "white"
# c.colors.statusbar.insert.bg = "#6699cc"
# c.colors.statusbar.progress.bg = "#83a598"
# c.colors.statusbar.url.fg = "white"
# c.colors.statusbar.url.hover.fg = "aqua"
# c.colors.statusbar.url.success.http.fg = "white"
# c.colors.tabs.indicator.start = "#0000aa"
# c.colors.tabs.indicator.stop = "#00aa00"
# c.colors.tabs.indicator.error = "#ff0000"
# c.colors.tabs.odd.fg = "white"
# c.colors.tabs.odd.bg = "#2d2d2d"
# c.colors.tabs.even.fg = "white"
# c.colors.tabs.even.bg = "#2d2d2d"
# c.colors.tabs.selected.odd.fg = "#2d2d2d"
# c.colors.tabs.selected.odd.bg = "white"
# c.colors.tabs.selected.even.fg = "#2d2d2d"
# c.colors.tabs.selected.even.bg = "white"
# c.colors.webpage.bg = "white"
# c.fonts.completion.entry = "12pt SNFS Display"
# c.fonts.completion.category = " 12pt SNFS Display"
# c.fonts.debug_console = "10pt SNFS Display"
# c.fonts.hints = "12pt SNFS Display"
# c.fonts.tabs.selected = "10pt SFNS Display"
# c.fonts.tabs.unselected = "10pt SFNS Display"
# c.fonts.web.family.standard = None
## }}}


# config.set("content.images", True, "chrome-devtools://*")
# config.set("content.images", True, "devtools://*")
# config.set("content.javascript.enabled", True, "chrome-devtools://*")
# config.set("content.javascript.enabled", True, "devtools://*")
# config.set("content.javascript.enabled", True, "chrome://*/*")
# config.set("content.javascript.enabled", True, "qute://*/*")
