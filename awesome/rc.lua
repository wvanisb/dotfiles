--[[
.   ______     __     __     ______     ______     ______     __    __     ______
.  /\  __ \   /\ \  _ \ \   /\  ___\   /\  ___\   /\  __ \   /\ "-./  \   /\  ___\
.  \ \  __ \  \ \ \/ ".\ \  \ \  __\   \ \___  \  \ \ \/\ \  \ \ \-./\ \  \ \  __\
.   \ \_\ \_\  \ \__/".~\_\  \ \_____\  \/\_____\  \ \_____\  \ \_\ \ \_\  \ \_____\
.    \/_/\/_/   \/_/   \/_/   \/_____/   \/_____/   \/_____/   \/_/  \/_/   \/_____/
-
]]


local awesome, client, mouse, screen, tag = awesome, client, mouse, screen, tag
local ipairs, string, os, table, tostring, tonumber, type = ipairs, string, os, table, tostring, tonumber, type
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")

-- Notification library
local naughty = require("naughty")
-- Declarative object management
local ruled = require("ruled")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
naughty.connect_signal("request::display_error", function(message, startup)
    naughty.notification {
      urgency = "critical",
      title = "Oops, an error happened" .. (startup and " during startup!" or "!"),
      message = message
    }
  end)
-- }}}
require("keys")
-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
mytheme = gears.filesystem.get_configuration_dir() .. "themes/mytheme/theme.lua"

beautiful.init(mytheme)
-- This is used later as the default terminal and editor to run.
terminal = '/usr/bin/alacritty'
editor = '/usr/bin/nvim'
editor_cmd = terminal .. " -e " .. editor
launcher = '/usr/local/bin/dmenu_run'
browser = '/usr/bin/brave'

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.

-- }}}

-- {{{ Menu
-- Create a launcher widget and a main menu
myawesomemenu = {
  {"hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end},
  {"manual", terminal .. " -e man awesome"},
  {"edit config", editor_cmd .. " " .. awesome.conffile},
  {"restart", awesome.restart},
  {"quit", function() awesome.quit() end},
}

mymainmenu = awful.menu({items = {{"awesome", myawesomemenu, beautiful.awesome_icon},
      {"open terminal", terminal}
    }
  })

mylauncher = awful.widget.launcher({image = beautiful.awesome_icon,
    menu = mymainmenu})

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- {{{ Tag layout
-- Table of layouts to cover with awful.layout.inc, order matters.
tag.connect_signal("request::default_layouts", function()
    awful.layout.append_default_layouts({
        awful.layout.suit.tile,
        awful.layout.suit.max.fullscreen,
        awful.layout.suit.floating,
      })
  end)
-- }}}

-- {{{ Wallpaper
screen.connect_signal("request::wallpaper", function(s)
    awful.wallpaper {
      screen = s,
      widget = {
        {
          image = beautiful.wallpaper,
          upscale = true,
          downscale = true,
          widget = wibox.widget.imagebox,
        },
        valign = "center",
        halign = "center",
        tiled = false,
        widget = wibox.container.tile,
      }
    }
  end)
-- }}}

-- {{{ Wibar

-- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()

-- Create a textclock widget
mytextclock = wibox.widget.textclock()

screen.connect_signal("request::desktop_decoration", function(s)
    -- Each screen has its own tag table.
    awful.tag({"1", "2", "3", "4", "5", "6", "7", "8", "9"}, s, awful.layout.layouts[1])

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()

    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox {
      screen = s,
      buttons = {
        awful.button({}, 1, function () awful.layout.inc(1) end),
        awful.button({}, 3, function () awful.layout.inc(-1) end),
        awful.button({}, 4, function () awful.layout.inc(-1) end),
        awful.button({}, 5, function () awful.layout.inc(1) end),
      }
    }

   --[[ local icons	= beautiful.icons.taglist
    local taglist = {}

    taglist.template = {
      {
        image	= gears.color.recolor_image(icons.unfocus, cs.fg),
        widget	= wibox.widget.imagebox,
      },
    

      id = 'index_role',
--      left	= 0,
--	    right	= 0,
	    -- widget	= wibox.container.margin,

      create_callback = function(self, c3, index, objects) --luacheck: no unused args
        self:get_children_by_id('index_role')[1].markup = '<b> '..index..' </b>'
        self:connect_signal('mouse::enter', function()
            if self.bg ~= '#ff0000' then
                self.backup     = self.bg
                self.has_backup = true
            end
            self.bg = '#ff0000'
        end)
        self:connect_signal('mouse::leave', function()
            if self.has_backup then self.bg = self.backup end
        end)
      end,

      update_callback = function(self, c3, index, objects) --luacheck: no unused args
        self:get_children_by_id('index_role')[1].markup = '<b> '..index..' </b>'
      end,

    }
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist {
      screen = s,
      filter = awful.widget.taglist.filter.all,

      layout		= wibox.layout.fixed.horizontal,
      widget_template = taglist.template,

      buttons = {
        awful.button({}, 1, function(t) t:view_only() end),
        awful.button({modkey}, 1, function(t)
            if client.focus then
              client.focus:move_to_tag(t)
            end
          end),
        awful.button({}, 3, awful.tag.viewtoggle),
        awful.button({modkey}, 3, function(t)
            if client.focus then
              client.focus:toggle_tag(t)
            end
          end),
        awful.button({}, 4, function(t) awful.tag.viewprev(t.screen) end),
        awful.button({}, 5, function(t) awful.tag.viewnext(t.screen) end),
      }
    } ]]
    awful.screen.connect_for_each_screen(function(s)
              
              local fancy_taglist = require("fancy_taglist")
              s.mytaglist = fancy_taglist.new({
                  screen = s,
                  taglist_buttons = mytagbuttons,
                  tasklist_buttons = mytasklistbuttons
              })
              
          end)
    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist {
      screen = s,
      filter = awful.widget.tasklist.filter.currenttags,
      buttons = {
        awful.button({}, 3, function() awful.menu.client_list {theme = {width = 250}} end),
        awful.button({}, 4, function() awful.client.focus.byidx(-1) end),
        awful.button({}, 5, function() awful.client.focus.byidx(1) end),
      }
    }

    -- Create the wibox
    s.mywibox = awful.wibar {
      position = "top",
      screen = s,
      widget = {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
          layout = wibox.layout.fixed.horizontal,
          mylauncher,
          s.mytaglist,
          s.mypromptbox,
        },
        s.mytasklist, -- Middle widget
        { -- Right widgets
          layout = wibox.layout.fixed.horizontal,
          mykeyboardlayout,
          wibox.widget.systray(),
          mytextclock,
          s.mylayoutbox,
        },
      }
    }


  end)

-- }}}

-- {{{ Mouse bindings
awful.mouse.append_global_mousebindings({
    awful.button({}, 3, function () mymainmenu:toggle() end),
    awful.button({}, 4, awful.tag.viewprev),
    awful.button({}, 5, awful.tag.viewnext),
  })
-- }}}

-- {{{ Rules
-- Rules to apply to new clients.
ruled.client.connect_signal("request::rules", function()
    -- All clients will match this rule.
    ruled.client.append_rule {
      id = "global",
      rule = {},
      properties = {
        focus = awful.client.focus.filter,
        raise = true,
        screen = awful.screen.preferred,
        placement = awful.placement.no_overlap + awful.placement.no_offscreen
      }
    }

    -- Floating clients.
    ruled.client.append_rule {
      id = "floating",
      rule_any = {
        instance = {"copyq", "pinentry"},
        class = {
          "Arandr", "Blueman-manager", "Gpick", "Kruler", "Sxiv",
          "Tor Browser", "Wpa_gui", "veromix", "xtightvncviewer"
        },
        -- Note that the name property shown in xprop might be set slightly after creation of the client
        -- and the name shown there might not match defined rules here.
        name = {
          "Event Tester",  -- xev.
        },
        role = {
          "AlarmWindow",    -- Thunderbird's calendar.
          "ConfigManager",  -- Thunderbird's about:config.
          "pop-up",         -- e.g. Google Chrome's (detached) Developer Tools.
        }
      },
      properties = {floating = true}
    }
end)
-- }}}

-- {{{ Notifications

ruled.notification.connect_signal('request::rules', function()
    -- All notifications will match this rule.
    ruled.notification.append_rule {
      rule = {},
      properties = {
        screen = awful.screen.preferred,
        implicit_timeout = 5,
      }
    }
  end)

naughty.connect_signal("request::display", function(n)
    naughty.layout.box {notification = n}
  end)

-- }}}

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    c:activate {context = "mouse_enter", raise = false}
  end)
  client.connect_signal("manage", function (c)
    c.shape = function(cr,w,h)
        gears.shape.rounded_rect(cr,w,h,7)
    end
end)



