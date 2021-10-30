-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
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
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")

-- Themes define colours, icons, font and wallpapers.
-- beautiful.init(gears.filesystem.get_themes_dir() .. "default/theme.lua")
beautiful.init(gears.filesystem.get_configuration_dir() .. "theme/theme.lua")

-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")



-- _____| _____| _____| _____| _____| _____| _____| _____| _____| _____| _____| _____|   



-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = tostring(err) })
        in_error = false
    end)
end
-- }}}



-- _____| _____| _____| _____| _____| _____| _____| _____| _____| _____| _____| _____|                                        



-- {{{ Variable definitions
-- This is used later as the default terminal and editor to run.
terminal          = "alacritty"
editor            = "emacsclient -c -a ''"
editor_cmd        = terminal.." -e " .. editor
editor_gui        = "emacsclient -c -a ''"
cmd_file_manager  = terminal.." -e mc -u"
gui_file_manager  = "thunar"
web_browser       = "firefox"
package_manager   = "pamac-manager"
print_scr         = "flameshot gui"

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey  = "Mod4"
Alt     = "Mod1"

-- Status Icons
--       v      
--     

clock_icon      = "🕑"
battery_icon    = "⚡"
battery_icon2   = "⚡"
volume_icon     = "🔊"
brightness_icon = ""
tray_icon       = "⚙"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
  awful.layout.suit.tile,
  -- awful.layout.suit.tile.left,
  -- awful.layout.suit.tile.bottom,
  -- awful.layout.suit.tile.top,
  awful.layout.suit.floating,
  -- awful.layout.suit.max,
  -- awful.layout.suit.max.fullscreen,
}
-- }}}



-- _____| _____| _____| _____| _____| _____| _____| _____| _____| _____| _____| _____|   



-- {{{ Menu
-- Create a launcher widget and a main menu
myawesomemenu = {
   { "hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", function() awesome.quit() end },
}

mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                    { "open terminal", terminal }
                                  }
                        })

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- {{{ Wibar
-- Clock
myclock_icon = wibox.widget.textbox(" "..clock_icon.."  ")
myclock_icon.font = "JetBrains Mono 11" or "sans 11"

myclockwidget = wibox.widget{
    {
        {
            myclock_icon,
            widget = wibox.container.background
        },
        {
            wibox.widget.textclock(),
            forced_width = 120,
            widget = wibox.container.margin
        },
        layout = wibox.layout.align.horizontal
    },
    widget = wibox.container.background
}

awful.widget.calendar_popup.month():attach( myclockwidget, "tr" )



-- _____| _____| _____| _____| _____| _____|



-- Battery Status
mybattery_icon = wibox.widget.textbox(" "..battery_icon.."  ")
mybattery_icon.font = "JetBrains Mono 11" or "sans 11"

mybatterywidget = wibox.widget{
    {
        {
            mybattery_icon,
            widget = wibox.container.background
        },
        {
            awful.widget.watch('cat /sys/class/power_supply/BAT0/capacity', 5, function(widget, out)
                widget:set_text(out)
            end),
            right = 12,
            widget = wibox.container.background
        },
        {
            wibox.widget.textbox("%"),
            right = 12,
            widget = wibox.container.margin
        },
        layout = wibox.layout.align.horizontal
    },
    widget = wibox.container.background
}

mybatterywidget:buttons(
  gears.table.join(
    awful.button({ }, 1, function ()
        awful.spawn(terminal.." -e sudo tlp start")
    end)
  )
)

awful.tooltip {
    objects        = {mybatterywidget},
    timer_function = function()
        return "Start TLP"
    end,
}

bat_info = ""

awful.widget.watch('acpi -b', 5, function(widget, stdout)
  for line in stdout:gmatch("[^\r\n]+") do
    if line:match("Battery 0") then
      bat_info = line
    end
  end
end)


awful.tooltip {
    objects        = {mybatterywidget},
    timer_function = function()
        return bat_info.."\n\nClick to start TLP"
    end,
}



-- _____| _____| _____| _____| _____| _____|



-- Battery 2
mybattery2_icon = wibox.widget.textbox(" "..battery_icon2.."  ")
mybattery2_icon.font = "JetBrains Mono 11" or "sans 11"

mybatterywidget2 = wibox.widget{
    {
        {
            mybattery2_icon,
            widget = wibox.container.background
        },
        {
            awful.widget.watch('cat /sys/class/power_supply/BAT1/capacity', 5),
            right = 12,
            widget = wibox.container.background
        }, 
        {
            wibox.widget.textbox("%"),
            right = 12,
            widget = wibox.container.margin
        },
        layout = wibox.layout.align.horizontal
    },
    widget = wibox.container.background
}

mybatterywidget2:buttons(
  gears.table.join(
    awful.button({ }, 1, function ()
        awful.spawn(terminal.." -e sudo tlp start")
    end)
  )
)

bat2_info = ""

awful.widget.watch('acpi -b', 5, function(widget, stdout)
  for line in stdout:gmatch("[^\r\n]+") do
    if line:match("Battery 1") then
      bat2_info = line
    end
  end
end)


awful.tooltip {
    objects        = {mybatterywidget2},
    timer_function = function()
        return bat2_info.."\n\nClick to start TLP"
    end,
}



-- _____| _____| _____| _____| _____| _____|



-- Volume Status
myvolume_icon = wibox.widget.textbox(" "..volume_icon.."  ")
myvolume_icon.font = "JetBrains Mono 11" or "sans 11"

myvolumewidget = wibox.widget{
    {
        {
            myvolume_icon,
            widget = wibox.container.background
        },
        {
            awful.widget.watch('pamixer --get-volume-human', 0.5),
            right = 12,
            widget = wibox.container.margin
        },
        layout = wibox.layout.align.horizontal
    },
    widget = wibox.container.background
}

myvolumewidget:buttons(
  gears.table.join(
    awful.button({ }, 1, function ()
        awful.spawn("pavucontrol")
    end),
    awful.button({ }, 2, function ()
        awful.spawn(terminal.." -e alsamixer")
    end)
  )
)

awful.tooltip {
    objects        = {myvolumewidget},
    timer_function = function()
        return "Open sound mixer"
    end,
}



-- _____| _____| _____| _____| _____| _____|



-- Brightness
mybrightness_icon = wibox.widget.textbox(" "..brightness_icon.."  ")
mybrightness_icon.font = "JetBrains Mono 11" or "sans 11"

mybrightnesswidget = wibox.widget{
    {
        {
            mybrightness_icon,
            widget = wibox.container.background
        },
        {
            awful.widget.watch('xbacklight -get', 0.5, function(widget, out)
              widget:set_text(math.floor(out).."%")
            end),
            right = 12,
            widget = wibox.container.margin
        },
        layout = wibox.layout.align.horizontal
    },
    widget = wibox.container.background
}

awful.tooltip {
    objects        = {mybrightnesswidget},
    timer_function = function()
        return "Brightness"
    end,
}



-- _____| _____| _____| _____| _____| _____|



-- Systemtray
mytray_icon = wibox.widget.textbox(" "..tray_icon.." ")
mytray_icon.font = "JetBrains Mono 11" or "sans 11"
wibox.widget.systray().visible = false
mytraywidget = wibox.widget{
    mytray_icon,
    widget = wibox.container.background()
}

mytraywidget:buttons(
  gears.table.join(
    awful.button({ }, 1, function ()
        wibox.widget.systray().visible = not wibox.widget.systray().visible
    end)
  )
)

awful.tooltip {
    objects        = {mytraywidget},
    timer_function = function()
        return "Toogle tray"
    end,
}



-- _____| _____| _____| _____| _____| _____|



-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
                    awful.button({ }, 1, function(t) t:view_only() end),
                    awful.button({ modkey }, 1, function(t)
                                              if client.focus then
                                                  client.focus:move_to_tag(t)
                                              end
                                          end),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, function(t)
                                              if client.focus then
                                                  client.focus:toggle_tag(t)
                                              end
                                          end),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
                )

local tasklist_buttons = gears.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  c:emit_signal(
                                                      "request::activate",
                                                      "tasklist",
                                                      {raise = true}
                                                  )
                                              end
                                          end),
                     awful.button({ }, 3, function()
                                              awful.menu.client_list({ theme = { width = 250 } })
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                          end))




-- _____| _____| _____| _____| _____| _____|



local function set_wallpaper(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)



-- _____| _____| _____| _____| _____| _____|



awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    set_wallpaper(s)

    -- Each screen has its own tag table.
    awful.tag({ "I", "II", "III", "IV", "V" }, s, awful.layout.layouts[1])
    
    
    
    -- _____| _____| _____| _____| _____| _____|
    
    
    
    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
                           awful.button({ }, 1, function () awful.layout.inc( 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(-1) end),
                           awful.button({ }, 4, function () awful.layout.inc( 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(-1) end)))
    
    
    
    -- _____| _____| _____| _____| _____| _____|
    
    
    
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.noempty,
        buttons = taglist_buttons,
    }
    

    
    -- _____| _____| _____| _____| _____| _____|
    
    
    
    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist {
        screen  = s,
        filter  = awful.widget.tasklist.filter.currenttags,
        buttons = tasklist_buttons,
        layout  = {
        spacing = 0,
        layout  = wibox.layout.flex.horizontal
      },
      widget_template = {
        { 
            {
                nil,
                {
                    id     = 'text_role',
                    widget = wibox.widget.textbox,
                },
                expand = "none", -- Center text
                layout = wibox.layout.align.horizontal,
            },
            left   = 5,
            right  = 5,
            widget = wibox.container.margin
        },
            id     = 'background_role',
            widget = wibox.container.background,
        },
    }
    
    
    
    -- _____| _____| _____| _____| _____| _____|
    
    
    -- Create the wibox
    s.mywibox = awful.wibar({ position = "top", opacity = 0.9, screen = s })

    -- Add widgets to the wibox
    s.mywibox:setup {
        { -- Left widgets
            -- mylauncher,
            s.mytaglist,
            s.mypromptbox,
            layout = wibox.layout.fixed.horizontal,
        },
        s.mytasklist, -- Middle widget
        { -- Right widgets
            wibox.widget.systray(),
            mytraywidget,
            -- {{{Status icons
            -- Volume
            myvolumewidget,
              
            -- Brightness
            mybrightnesswidget,
              
            -- Battery
            mybatterywidget,
            mybatterywidget2,
            -- }}}
            myclockwidget,
            -- s.mylayoutbox,
            layout = wibox.layout.fixed.horizontal,
        },
        layout = wibox.layout.align.horizontal
    }
end)
-- }}}


-- _____| _____| _____| _____| _____| _____| _____| _____| _____| _____| _____| _____|   


-- {{{ Mouse bindings
root.buttons(gears.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}



-- _____| _____| _____| _____| _____| _____| _____| _____| _____| _____| _____| _____|   



-- {{{ Key bindings
globalkeys = gears.table.join(
    awful.key({ modkey,           }, "s",      hotkeys_popup.show_help,
              {description="show help", group="awesome"}),
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev,
              {description = "view previous", group = "tag"}),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext,
              {description = "view next", group = "tag"}),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
              {description = "go back", group = "tag"}),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
        end,
        {description = "focus next by index", group = "client"}
    ),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
        end,
        {description = "focus previous by index", group = "client"}
    ),
    awful.key({ modkey,        Alt}, "p", function () mymainmenu:show() end,
              {description = "show main menu", group = "awesome"}),



    -- _____| _____| _____| _____| _____| _____|



    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end,
              {description = "swap with next client by index", group = "client"}),
    
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end,
              {description = "swap with previous client by index", group = "client"}),
    
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end,
              {description = "focus the next screen", group = "screen"}),
    
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end,
              {description = "focus the previous screen", group = "screen"}),
    
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
              {description = "jump to urgent client", group = "client"}),
    
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "go back", group = "client"}),



    -- _____| _____| _____| _____| _____| _____|



    -- Audio
    awful.key({  }, "XF86AudioPlay", function () awful.spawn.with_shell("playerctl play-pause") end,
              {description = "audio player toggle", group = "audio"}),
    awful.key({  }, "XF86AudioNext", function () awful.spawn.with_shell("playerctl next") end,
              {description = "audio player next", group = "audio"}),
    awful.key({  }, "XF86AudioPrev", function () awful.spawn.with_shell("playerctl previous") end,
              {description = "audio player previous", group = "audio"}),
    awful.key({  }, "XF86AudioStop", function () awful.spawn.with_shell("playerctl stop") end,
              {description = "audio player stop", group = "audio"}),
    awful.key({  }, "XF86AudioMute", function () awful.spawn.with_shell("pactl set-sink-mute @DEFAULT_SINK@ toggle") end,
              {description = "audio (un)mute", group = "audio"}),
    awful.key({  }, "XF86AudioMicMute", function () awful.spawn.with_shell("pactl set-source-mute @DEFAULT_SOURCE@ toggle") end,
              {description = "(un)mute microphone", group = "audio"}),
    awful.key({  }, "XF86AudioRaiseVolume", function () awful.spawn.with_shell("pamixer -i 2") end,
              {description = "audio raise", group = "audio"}),
    awful.key({  }, "XF86AudioLowerVolume", function () awful.spawn.with_shell("pamixer -d 2") end,
              {description = "audio lower", group = "audio"}),


    -- _____| _____| _____| _____| _____| _____|
    
    
    
    -- Brightness
    awful.key({  }, "XF86MonBrightnessUp", function () awful.spawn.with_shell("xbacklight -inc 5") end,
              {description = "increase brightness", group = "brightness"}),
    awful.key({  }, "XF86MonBrightnessDown", function () awful.spawn.with_shell("xbacklight -dec 5") end,
              {description = "decrease brightness", group = "brightness"}),
    
    
    
    -- _____| _____| _____| _____| _____| _____|
    
    
        
    -- Awesome
    awful.key({ modkey, "Control" }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),
    awful.key({ modkey, "Shift" }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),
    
    
    
    -- _____| _____| _____| _____| _____| _____|



    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.spawn(terminal) end,
              {description = "open a terminal", group = "launcher"}),
    
    awful.key({ modkey, "Control" }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),
    
    awful.key({ modkey, "Control" }, "q", awesome.quit,
              {description = "quit awesome", group = "awesome"}),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)          end,
              {description = "increase master width factor", group = "layout"}),
    
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)          end,
              {description = "decrease master width factor", group = "layout"}),
    
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1, nil, true) end,
              {description = "increase the number of master clients", group = "layout"}),
    
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1, nil, true) end,
              {description = "decrease the number of master clients", group = "layout"}),
    
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1, nil, true)    end,
              {description = "increase the number of columns", group = "layout"}),
    
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1, nil, true)    end,
              {description = "decrease the number of columns", group = "layout"}),
    
    awful.key({ modkey,           }, "space", function () awful.layout.inc( 1)                end,
              {description = "select next", group = "layout"}),
    
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(-1)                end,
              {description = "select previous", group = "layout"}),

    
    awful.key({ modkey, "Control" }, "n",
              function ()
                  local c = awful.client.restore()
                  -- Focus restored client
                  if c then
                    c:emit_signal(
                        "request::activate", "key.unminimize", {raise = true}
                    )
                  end
              end,
              {description = "restore minimized", group = "client"}),
    
    
    
    -- _____| _____| _____| _____| _____| _____|
    
    
    
    -- Prompt
    awful.key({ modkey },            "r",     function () awful.screen.focused().mypromptbox:run() end,
              {description = "run prompt", group = "launcher"}),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run {
                    prompt       = "Run Lua code: ",
                    textbox      = awful.screen.focused().mypromptbox.widget,
                    exe_callback = awful.util.eval,
                    history_path = awful.util.get_cache_dir() .. "/history_eval"
                  }
              end,
              {description = "lua execute prompt", group = "awesome"}),
    
    
    
    -- _____| _____| _____| _____| _____| _____|
    
    
    -- Menubar
    awful.key({ modkey }, "p", function()
                                  menubar.refresh()
                                  menubar.show()
                              end,
              {description = "show the menubar", group = "launcher"}),



    -- _____| _____| _____| _____| _____| _____|



    -- Apps
    
    -- web
    awful.key({ modkey,           },      "w", function () awful.spawn(web_browser) end,
              {description = "open browser", group = "apps"}),
    
    -- screenshoots
    --awful.key({                   },  "Print", function () awful.spawn(print_scr) end,
    --          {description = "take a screenshot", group = "apps"}),
    
    -- gui code editor
    awful.key({modkey,           },       "e", function () awful.spawn(editor_gui) end,
              {description = "open a gui editor", group = "apps"}),

    -- package manager
    awful.key({ modkey,        Alt},      "m", function () awful.spawn(package_manager) end,
              {description = "open package manager", group = "apps"}),
    
    -- gui file manager
    awful.key({ modkey,           },      "d", function () awful.spawn(gui_file_manager) end,
              {description = "open file manager", group = "apps"}),
    
    -- cmd file manager
    awful.key({ modkey,        Alt},      "d", function () awful.spawn(cmd_file_manager) end,
              {description = "open commandline file manager", group = "apps"})
)

clientkeys = gears.table.join(
    awful.key({ modkey,           }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "toggle fullscreen", group = "client"}),
    
    awful.key({ modkey, "Shift"   }, "q",      function (c) c:kill()                         end,
              {description = "close", group = "client"}),
    
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ,
              {description = "toggle floating", group = "client"}),
    
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
              {description = "move to master", group = "client"}),
    
    awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()               end,
              {description = "move to screen", group = "client"}),
    
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
              {description = "toggle keep on top", group = "client"}),
    
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end ,
        {description = "minimize", group = "client"}),
    
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized = not c.maximized
            c:raise()
        end ,
        {description = "(un)maximize", group = "client"}),
    
    awful.key({ modkey, "Control" }, "m",
        function (c)
            c.maximized_vertical = not c.maximized_vertical
            c:raise()
        end ,
        {description = "(un)maximize vertically", group = "client"}),
    
    awful.key({ modkey, "Shift"   }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c:raise()
        end ,
        {description = "(un)maximize horizontally", group = "client"})
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = gears.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                           tag:view_only()
                        end
                  end,
                  {description = "view tag #"..i, group = "tag"}),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = screen.tags[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end,
                  {description = "toggle tag #" .. i, group = "tag"}),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end,
                  {description = "move focused client to tag #"..i, group = "tag"}),
        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:toggle_tag(tag)
                          end
                      end
                  end,
                  {description = "toggle focused client on tag #" .. i, group = "tag"})
    )
end

clientbuttons = gears.table.join(
    awful.button({ }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
    end),
    awful.button({ modkey }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, 3, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.resize(c)
    end)
)

-- Set keys
root.keys(globalkeys)
-- }}}


-- _____| _____| _____| _____| _____| _____| _____| _____| _____| _____| _____| _____|   


-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     screen = awful.screen.preferred,
                     placement = awful.placement.no_overlap+awful.placement.no_offscreen
     }
    },

    -- Floating clients.
    { rule_any = {
        instance = {
          "DTA",  -- Firefox addon DownThemAll.
          "copyq",  -- Includes session name in class.
          "pinentry",
        },
        class = {
          "Arandr",
          "Blueman-manager",
          "Gpick",
          "Kruler",
          --"MessageWin",  -- kalarm.
          --"Sxiv",
          "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
          "Wpa_gui",
          "veromix",
          "xtightvncviewer"},

        -- Note that the name property shown in xprop might be set slightly after creation of the client
        -- and the name shown there might not match defined rules here.
        name = {
          "Event Tester",  -- xev.
        },
        role = {
          "AlarmWindow",  -- Thunderbird's calendar.
          "ConfigManager",  -- Thunderbird's about:config.
          "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
        }
      }, properties = { floating = true }},

    -- Set Firefox to always map on the tag named "2" on screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { screen = 1, tag = "2" } },

    -- Add titlebars to normal clients and dialogs
    { rule_any = {type = { "normal", "dialog" }
      }, properties = { titlebars_enabled = true }
    },

}
-- }}}



-- _____| _____| _____| _____| _____| _____| _____| _____| _____| _____| _____| _____|   


-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup
      and not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)


-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = gears.table.join(
        awful.button({ }, 1, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.move(c)
        end),
        awful.button({ }, 3, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.resize(c)
        end)
    )

    awful.titlebar(c) : setup {
        { -- Left
            -- awful.titlebar.widget.iconwidget(c),
            wibox.widget.textbox(" window: "),
            buttons = buttons,
            layout  = wibox.layout.fixed.horizontal
        },
        { -- Middle
            { -- Title
                align  = "left",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        layout = wibox.layout.align.horizontal
    }
end)  



-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", {raise = false})
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)


-- Rounded boarder
--client.connect_signal("manage", function (c)
--    if not c.maximized then
--        c.shape = gears.shape.rounded_rect
--    end
--end)

-- client.connect_signal("property::maximized", function (c)
--     c.shape = gears.shape.rectangle
-- end)
-- }}}

