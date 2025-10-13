# Minimal qutebrowser config for macOS (no Xresources)
# Colors: greyscale / black | Font: JetBrainsMono Nerd Font
# Adblocking enabled | Minimal UI

config.load_autoconfig()  # Load settings made via :set etc.

# =========================
# Colors (Monochrome theme)
# =========================

bg = "#181818"
fg = "#e0e0e0"
grey1 = "#333333"
grey2 = "#444444"
grey3 = "#555555"
grey4 = "#888888"

# Statusbar
c.colors.statusbar.normal.bg = bg
c.colors.statusbar.normal.fg = fg
c.colors.statusbar.command.bg = bg
c.colors.statusbar.command.fg = fg
c.colors.statusbar.url.fg = grey4
c.colors.statusbar.url.success.https.fg = fg
c.colors.statusbar.url.hover.fg = grey3
c.colors.statusbar.passthrough.fg = grey4

# Tabs
c.colors.tabs.bar.bg = bg
c.colors.tabs.even.bg = bg
c.colors.tabs.odd.bg = bg
c.colors.tabs.even.fg = grey2
c.colors.tabs.odd.fg = grey2
c.colors.tabs.selected.even.bg = fg
c.colors.tabs.selected.odd.bg = fg
c.colors.tabs.selected.even.fg = bg
c.colors.tabs.selected.odd.fg = bg
c.tabs.padding = {'top': 4, 'bottom': 4, 'left': 8, 'right': 8}
c.tabs.indicator.width = 0
c.tabs.width = '10%'
c.tabs.show = "multiple"

# Completion
c.colors.completion.odd.bg = bg
c.colors.completion.even.bg = bg
c.colors.completion.fg = fg
c.colors.completion.category.bg = bg
c.colors.completion.category.fg = fg
c.colors.completion.item.selected.bg = grey1
c.colors.completion.item.selected.fg = fg
c.colors.completion.match.fg = grey3
c.colors.completion.item.selected.match.fg = grey3

# Hints
c.colors.hints.bg = bg
c.colors.hints.fg = fg
c.hints.border = fg

# Messages
c.colors.messages.info.bg = bg
c.colors.messages.info.fg = fg
c.colors.messages.error.bg = bg
c.colors.messages.error.fg = fg

# Downloads
c.colors.downloads.bar.bg = bg
c.colors.downloads.error.bg = bg
c.colors.downloads.error.fg = fg
c.colors.downloads.start.bg = grey3
c.colors.downloads.start.fg = fg
c.colors.downloads.stop.bg = grey2
c.colors.downloads.stop.fg = fg

# Tooltips & Webpage
c.colors.tooltip.bg = bg
c.colors.webpage.bg = bg

# Dark mode
c.colors.webpage.darkmode.enabled = True
c.colors.webpage.darkmode.algorithm = 'lightness-cielab'
c.colors.webpage.darkmode.policy.images = 'never'
config.set('colors.webpage.darkmode.enabled', False, 'file://*')

# =============
# Fonts
# =============

c.fonts.default_family = ["JetBrainsMono Nerd Font", "monospace"]
c.fonts.default_size = "13pt"

c.fonts.web.family.fixed = "JetBrainsMono Nerd Font"
c.fonts.web.family.sans_serif = "JetBrainsMono Nerd Font"
c.fonts.web.family.serif = "JetBrainsMono Nerd Font"
c.fonts.web.family.standard = "JetBrainsMono Nerd Font"
c.fonts.web.size.default = 18

# =============
# Privacy
# =============

config.set("content.webgl", False)
config.set("content.canvas_reading", False)
config.set("content.geolocation", False)
config.set("content.webrtc_ip_handling_policy", "default-public-interface-only")
config.set("content.cookies.accept", "all")
config.set("content.cookies.store", True)
# config.set("content.javascript.enabled", False)  # Optional toggle

# ==================
# Adblocking Setup
# ==================

c.content.blocking.enabled = True
c.content.blocking.method = 'both'
c.content.blocking.adblock.lists = [
    "https://easylist.to/easylist/easylist.txt",
    "https://easylist.to/easylist/easyprivacy.txt",
    "https://github.com/uBlockOrigin/uAssets/raw/master/filters/filters.txt",
]
c.content.blocking.hosts.lists = [
    "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"
]

# After setup, run `:adblock-update` inside qutebrowser to fetch filters.

# ==================
# Keybindings
# ==================

config.bind("tH", "config-cycle tabs.show multiple never")
config.bind("sH", "config-cycle statusbar.show always never")
config.bind("pp", "open -- {clipboard}")
config.bind("pt", "open -t -- {clipboard}")
config.bind("T", "hint links tab")
config.bind("gm", "tab-move")
config.bind("gJ", "tab-move +")
config.bind("gK", "tab-move -")
config.bind(",m", "hint links spawn mpv {hint-url}")
config.bind("cs", "config-source")

# ==================
# Misc
# ==================

c.statusbar.show = "in-mode"
c.auto_save.session = True
c.url.searchengines = {
    'DEFAULT': 'https://duckduckgo.com/?q={}',
    '!gh': 'https://github.com/search?q={}',
    '!aw': 'https://wiki.archlinux.org/?search={}',
    '!apkg': 'https://archlinux.org/packages/?q={}',
    '!yt': 'https://www.youtube.com/results?search_query={}',
}

# Optional start page
# c.url.start_pages = "https://start.duckduckgo.com"
# c.url.default_page = "https://start.duckduckgo.com"

