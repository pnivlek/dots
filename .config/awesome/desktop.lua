-------------------------------------------------
--               AwesomeWM Config              --
--                desktop.lua  		       --
-------------------------------------------------

-- Base libraries
local awful = require('awful')
local gears = require('gears')
-- local widgets = require('widgets')
local env = require('env')

-- Set up some desktop settings.
awful.layout.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.floating,
    awful.layout.suit.max
}

-- Menu
myawesomemenu = {
    { "hotkeys", function() return false, hotkeys_popup.show_help end, icons.keyboard},
    { "restart", awesome.restart, icons.reboot },
    { "quit", function() exit_screen_show() end, icons.poweroff}
}

mymainmenu = awful.menu({
    items = {
        { "awesome", myawesomemenu, icons.home },
        { "firefox", user.browser, icons.firefox },
        { "terminal", user.terminal, icons.terminal },
        { "files", user.file_manager, icons.files },
        { "search", "rofi -matching fuzzy -show combi", icons.search },
    }
})

mylauncher = awful.widget.launcher({
    image = beautiful.awesome_icon,
    menu = mymainmenu
})

require('menubar')
menubar.utils.terminal = env.terminal

-- Wallpaper
local function set_wallpaper(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        awful.spawn.with_shell("feh --bg-fill " .. wallpaper)
    end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

-- Set up screens
awful.screen.connect_for_each_screen(function(s)
	set_wallpaper(s)
	local l = awful.layout.suit
	local layouts = {
		l.tile, l.tile, l.tile, l.tile, l.tile, l.tile, l.tile, l.tile, l.tile, l.tile,
		l.tile, l.tile, l.tile, l.tile, l.tile, l.tile, l.tile, l.tile, l.tile, l.tile,
	}

    	local tagnames = beautiful.tagnames or { "1", "2", "3", "4", "5", "6", "7", "8", "9", "10",
						 "11", "12", "13", "14", "15", "16", "17", "18", "19", "20" }
	awful.tag(tagnames, s, layouts)
end)

-- Rules
awful.rules.rules = {
	{
        -- All clients will match this rule.
        rule = { },
        properties = {
            border_width = beautiful.border_width,
            border_color = beautiful.border_normal,
            focus = awful.client.focus.filter,
            raise = true,
            keys = keys.clientkeys,
            buttons = keys.clientbuttons,
            -- screen = awful.screen.preferred,
            screen = awful.screen.focused,
            size_hints_honor = false,
            honor_workarea = true,
            honor_padding = true,
            -- placement = awful.placement.no_overlap+awful.placement.no_offscreen
        },
        callback = function (c)
            if not awesome.startup then
                -- If the layout is floating or there are no other visible clients
                -- Apply placement function
                if awful.layout.get(mouse.screen) ~= awful.layout.suit.floating or #mouse.screen.clients == 1 then
                    awful.placement.centered(c,{honor_padding = true, honor_workarea=true})
                else
                    client_placement_f(c, {honor_padding = true, honor_workarea=true, margins = beautiful.useless_gap * 2})
                end

                -- Hide titlebars if required by the theme
                if not beautiful.titlebars_enabled then
                    decorations.hide(c)
                    -- awful.titlebar.hide(c)
                end

            end
        end
    },
    {
        rule_any = {
            class = {
                "qutebrowser",
                "discord",
                "Steam",
                "Chromium",
            },
        },
        properties = {},
        callback = function (c)
            if not beautiful.titlebars_imitate_borders then
                decorations.hide(c)
                -- awful.titlebar.hide(c)
            end
        end
    }
}



-- Signals
client.connect_signal("manage", function(c)
	if not awesome.startup then awful.client.setslave(c) end
end)

if beautiful.border_width > 0 then
    client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
    client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
end

-- Restore geometry for floating clients
-- (for example after swapping from tiling mode to floating mode)
-- ==============================================================
tag.connect_signal('property::layout', function(t)
    for k, c in ipairs(t:clients()) do
        if awful.layout.get(mouse.screen) == awful.layout.suit.floating then
            -- Geometry x = 0 and y = 0 most probably means that the client's
            -- floating_geometry has not been set yet.
            -- If that is the case, don't change their geometry
            -- TODO does this affect clients that are really placed in 0,0 ?
            local cgeo = awful.client.property.get(c, 'floating_geometry')
            if cgeo and not (cgeo.x == 0 and cgeo.y == 0) then
                c:geometry(awful.client.property.get(c, 'floating_geometry'))
            end
            --c:geometry(awful.client.property.get(c, 'floating_geometry'))
        end
    end
end)

client.connect_signal('manage', function(c)
    if awful.layout.get(mouse.screen) == awful.layout.suit.floating then
        awful.client.property.set(c, 'floating_geometry', c:geometry())
    end
end)

client.connect_signal('property::geometry', function(c)
    if awful.layout.get(mouse.screen) == awful.layout.suit.floating then
        awful.client.property.set(c, 'floating_geometry', c:geometry())
    end
end)
