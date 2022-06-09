-------------------------------
--  "Zenburn" awesome theme  --
--    By Adrian C. (anrxc)   --
-------------------------------

local themes_path = require("gears.filesystem").get_configuration_dir() .. "themes/"
local rnotification = require("ruled.notification")
local dpi = require("beautiful.xresources").apply_dpi

-- {{{ Main
local theme = {}
theme.wallpaper = themes_path .. "mytheme/background.png"
-- }}}

-- {{{ Styles
theme.font      = "Roboto 10"

-- {{{ Colors
theme.fg_normal  = "#DCDCCC"
theme.fg_focus   = "#F0DFAF"
theme.fg_urgent  = "#CC9393"
theme.bg_normal  = "#3F3F3F"
theme.bg_focus   = "#1E2320"
theme.bg_urgent  = "#3F3F3F"
theme.bg_systray = theme.bg_normal
-- }}}

-- {{{ Borders
theme.useless_gap   = dpi(6)
theme.border_width  = dpi(2)
theme.border_color_normal = "#3F3F3F"
theme.border_color_active = "#6F6F6F"
theme.border_color_marked = "#CC9393"
-- }}}

-- {{{ Titlebars
theme.titlebar_bg_focus  = "#3F3F3F"
theme.titlebar_bg_normal = "#3F3F3F"
-- }}}

-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- [taglist|tasklist]_[bg|fg]_[focus|urgent|occupied|empty|volatile]
-- titlebar_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- Example:
--theme.taglist_bg_focus = "#CC9393"
-- }}}

-- {{{ Widgets
-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.fg_widget        = "#AECF96"
--theme.fg_center_widget = "#88A175"
--theme.fg_end_widget    = "#FF5656"
--theme.bg_widget        = "#494B4F"
--theme.border_widget    = "#3F3F3F"
-- }}}

-- {{{ Menu
-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_height = dpi(25)
theme.menu_width  = dpi(150)
-- }}}

-- {{{ Icons
-- {{{ Taglist
--theme.taglist_squares_sel   = themes_path .. "mytheme/taglist/squarefz.png"
-- theme.taglist_squares_unsel = themes_path .. "mytheme/taglist/squarez.png"
theme.taglist_spacing = dpi(10)
-- TODO theme.taglist_shape=

-- theme.corner_radius = dpi(15)
--theme.taglist_squares_resize = "false"
-- }}}

-- {{{ Misc
theme.awesome_icon           = themes_path .. "mytheme/awesome-icon.png"
theme.menu_submenu_icon      = themes_path .. "default/submenu.png"

theme.hotkeys_bg = "#000000"
theme.hotkeys_fg = "#ffffff"
theme.hotkeys_label_bg = "#111111"
theme.hotkeys_label_fg = "#FFFFFF"
theme.hotkeys_font           = "JetBrains Mono 11"
-- }}}

-- {{{ Layout
theme.layout_tile       = themes_path .. "mytheme/layouts/tile.png"
theme.layout_tileleft   = themes_path .. "mytheme/layouts/tileleft.png"
theme.layout_tilebottom = themes_path .. "mytheme/layouts/tilebottom.png"
theme.layout_tiletop    = themes_path .. "mytheme/layouts/tiletop.png"
theme.layout_fairv      = themes_path .. "mytheme/layouts/fairv.png"
theme.layout_fairh      = themes_path .. "mytheme/layouts/fairh.png"
theme.layout_spiral     = themes_path .. "mytheme/layouts/spiral.png"
theme.layout_dwindle    = themes_path .. "mytheme/layouts/dwindle.png"
theme.layout_max        = themes_path .. "mytheme/layouts/max.png"
theme.layout_fullscreen = themes_path .. "mytheme/layouts/fullscreen.png"
theme.layout_magnifier  = themes_path .. "mytheme/layouts/magnifier.png"
theme.layout_floating   = themes_path .. "mytheme/layouts/floating.png"
theme.layout_cornernw   = themes_path .. "mytheme/layouts/cornernw.png"
theme.layout_cornerne   = themes_path .. "mytheme/layouts/cornerne.png"
theme.layout_cornersw   = themes_path .. "mytheme/layouts/cornersw.png"
theme.layout_cornerse   = themes_path .. "mytheme/layouts/cornerse.png"
-- }}}

--[[ Titlebar
theme.titlebar_close_button_focus  = themes_path .. "mytheme/titlebar/close_focus.png"
theme.titlebar_close_button_normal = themes_path .. "mytheme/titlebar/close_normal.png"

theme.titlebar_minimize_button_normal = themes_path .. "default/titlebar/minimize_normal.png"
theme.titlebar_minimize_button_focus  = themes_path .. "default/titlebar/minimize_focus.png"

theme.titlebar_ontop_button_focus_active  = themes_path .. "mytheme/titlebar/ontop_focus_active.png"
theme.titlebar_ontop_button_normal_active = themes_path .. "mytheme/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_inactive  = themes_path .. "mytheme/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_inactive = themes_path .. "mytheme/titlebar/ontop_normal_inactive.png"

theme.titlebar_sticky_button_focus_active  = themes_path .. "mytheme/titlebar/sticky_focus_active.png"
theme.titlebar_sticky_button_normal_active = themes_path .. "mytheme/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_inactive  = themes_path .. "mytheme/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_inactive = themes_path .. "mytheme/titlebar/sticky_normal_inactive.png"

theme.titlebar_floating_button_focus_active  = themes_path .. "mytheme/titlebar/floating_focus_active.png"
theme.titlebar_floating_button_normal_active = themes_path .. "mytheme/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_inactive  = themes_path .. "mytheme/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_inactive = themes_path .. "mytheme/titlebar/floating_normal_inactive.png"

theme.titlebar_maximized_button_focus_active  = themes_path .. "mytheme/titlebar/maximized_focus_active.png"
theme.titlebar_maximized_button_normal_active = themes_path .. "mytheme/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_inactive  = themes_path .. "mytheme/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_inactive = themes_path .. "mytheme/titlebar/maximized_normal_inactive.png"
--]]

-- Set different colors for urgent notifications.
rnotification.connect_signal('request::rules', function()
    rnotification.append_rule {
        rule       = { urgency = 'critical' },
        properties = { bg = '#ff0000', fg = '#ffffff' }
    }
end)

return theme

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80