local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

math.randomseed(os.time())

local gfs = require("gears.filesystem")
local themes_path = gfs.get_themes_dir()

local theme = {}

-- wallpaper
theme.wallpaper = "~/.wallpapers/"..math.random(1,311)..".png"

-- font
theme.font             = "JetBrains Mono 7" or "sans 8"

-- colors

-- [nord]

-- Theme.bg_normal     = "#2e3440" -- "#222222"
-- Theme.bg_focus      = "#434c5e" -- "#535d6c"
-- Theme.bg_urgent     = "#bf616a" -- "#ff0000"
-- Theme.bg_minimize   = "#3b4252" -- "#444444"
-- Theme.bg_systray    = theme.bg_normal
-- 
-- Theme.fg_normal     = "#d8dee9" -- "#aaaaaa"
-- Theme.fg_focus      = "#eceff4" -- "#ffffff"
-- Theme.fg_urgent     = "#eceff4" -- "#ffffff"
-- Theme.fg_minimize   = "#e5e9f0" -- "#ffffff"

-- [flat remix]

-- {{{ Colors
theme.bg_normal     = "#23252e" -- "#222222"
theme.bg_focus      = "#2b2F3a" -- "#535d6c"
theme.bg_urgent     = "#bf616a" -- "#ff0000"
theme.bg_systray    = theme.bg_normal

theme.fg_normal     = "#cacbca" -- "#aaaaaa"
theme.fg_focus      = "#cacbca" -- "#ffffff"
theme.fg_urgent     = "#cacbca" -- "#ffffff"
-- }}}

-- {{{ Borders
theme.useless_gap   = dpi(0)
theme.border_width  = dpi(1)
theme.border_normal = "#2e3440" -- "#000000"
theme.border_focus  = "#3b4252" -- "#535d6c"
theme.border_marked = "#bf616a" -- "#91231c"
-- }}}

-- {{{ Titlebar
theme.titlebar_bg   = "#23252ee5"
theme.titlebar_fg   = "#cacbca"
-- }}}


-- [zenburn]

-- {{{ Colors
-- theme.fg_normal  = "#DCDCCC"
-- theme.fg_focus   = "#F0DFAF"
-- theme.fg_urgent  = "#CC9393"
-- theme.bg_normal  = "#3F3F3F"
-- theme.bg_focus   = "#1E2320"
-- theme.bg_urgent  = "#3F3F3F"
-- theme.bg_systray = theme.bg_normal
-- }}}

-- {{{ Borders
-- theme.useless_gap   = dpi(0)
-- theme.border_width  = dpi(2)
-- theme.border_normal = "#3F3F3F"
-- theme.border_focus  = "#6F6F6F"
-- theme.border_marked = "#CC9393"
-- }}}

-- {{{ Titlebars
-- theme.titlebar_bg_focus  = "#3F3F3F"
-- theme.titlebar_bg_normal = "#3F3F3F"
-- }}}


-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- taglist_[bg|fg]_[focus|urgent|occupied|empty|volatile]
-- tasklist_[bg|fg]_[focus|urgent]
-- titlebar_[bg|fg]_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- mouse_finder_[color|timeout|animate_timeout|radius|factor]
-- prompt_[fg|bg|fg_cursor|bg_cursor|font]
-- hotkeys_[bg|fg|border_width|border_color|shape|opacity|modifiers_fg|label_bg|label_fg|group_margin|font|description_font]
-- Example:
--theme.taglist_bg_focus = "#ff0000"

-- Generate taglist squares:
local taglist_square_size = dpi(4)
theme.taglist_squares_sel = theme_assets.taglist_squares_sel(
    taglist_square_size, theme.fg_normal
)
theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel(
    taglist_square_size, theme.fg_normal
)

-- Variables set for theming notifications:
-- notification_font
-- notification_[bg|fg]
-- notification_[width|height|margin]
-- notification_[border_color|border_width|shape|opacity]


-- {{{ Mouse finder
theme.mouse_finder_color = "#CC9393"
-- mouse_finder_[timeout|animate_timeout|radius|factor]
-- }}}


-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_height = dpi(15)
theme.menu_width  = dpi(100)

-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.bg_widget = "#cc0000"`

-- Generate Awesome icon:
-- theme.awesome_icon = theme_assets.awesome_icon(
--     theme.menu_height, theme.bg_focus, theme.fg_focus
-- )

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = nil

return theme

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
