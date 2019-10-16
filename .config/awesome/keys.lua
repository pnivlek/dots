-------------------------------------------------
--               AwesomeWM Config              --
--                   keys.lua  		       --
-------------------------------------------------

-- Base libraries
local awful = require('awful')
local gears = require('gears')
-- local widgets = require('widgets')
local env = require('env')

local keys = {}

local shift = "Shift"
local ctrl  = "Control"

-- Basic Keys
keys.globalkeys = gears.table.join(
	-- Terminals and the Program Launcher
	awful.key({ env.mod1 }, "Return",
		function () awful.spawn(env.terminal) end,
		{ description = "Open a terminal", group = "launcher"}),
	awful.key({ env.mod2 }, "Return",
		function () awful.spawn(env.quake_terminal, { floating=true }) end,
		{ description = "Open the overhead terminal", group = "launcher"}),
	awful.key({ env.mod, shift }, "Return",
		function () awful.spawn(env.launcher) end,
		{ description = "Open the program launcher", group = "launcher"}),

	awful.key({ env.mod1 , shift }, "q",
		function (c) c:kill() end,
		{ description = "Close a window", group = "client" }),
	awful.key({ env.mod1 }, "q",
		awesome.quit,
		{ description = "Quit Awesome", group = "awesome" })
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
-- env.mod1 + 1-10 = go to tag on first row, and only display.
-- env.mod1 + shift + 1-10 = send window to tag on first row
-- env.mod1 + ctrl + 1-10 = toggle tag display
-- env.mod1 + shift + ctrl + 1-10 = toggle whether or not the focused window has the tag
-- Same for mod2 with tags 11-20

local tag_rowlen = env.tag_num / env.tag_groups
local tag_groups = env.tag_groups-- = 2
for i = 1, tag_rowlen do
    keys.globalkeys = gears.table.join(keys.globalkeys,

        -- View tag only.
        awful.key({ env.mod1 }, "#" .. i + 9,
            function ()
                local tag = mouse.screen.tags[i]
                if tag then
			tag:view_only()
                end
            end,
            {description = "view tag #".. i, group = "tag"}),
        awful.key({ env.mod2 }, "#" .. i + 9,
            function ()
                local tag = mouse.screen.tags[i + tag_rowlen]
                if tag then
			tag:view_only()
                end
            end,
            {description = "view tag #".. i + tag_rowlen, group = "tag"}),

        -- Toggle tag display.
        awful.key({ env.mod1, ctrl }, "#" .. i + 9,
            function ()
                local screen = awful.screen.focused()
                local tag = screen.tags[i]
                if tag then
                    awful.tag.viewtoggle(tag)
                end
            end,
            {description = "toggle tag #" .. i, group = "tag"}),
        awful.key({ env.mod2, ctrl }, "#" .. i + 9,
            function ()
                local screen = awful.screen.focused()
                local tag = screen.tags[i + tag_rowlen]
                if tag then
                    awful.tag.viewtoggle(tag)
                end
            end,
            {description = "toggle tag #" .. i + tag_rowlen, group = "tag"}),

        -- Move client to tag.
        awful.key({ env.mod1, shift }, "#" .. i + 9,
            function ()
                if client.focus then
                    local tag = client.focus.screen.tags[i]
                    if tag then
                        client.focus:move_to_tag(tag)
                    end
                end
            end,
            {description = "move focused client to tag #"..i, group = "tag"}),
        awful.key({ env.mod2, shift }, "#" .. i + 9,
            function ()
                if client.focus then
                    local tag = client.focus.screen.tags[i + tag_rowlen]
                    if tag then
                        client.focus:move_to_tag(tag)
                    end
                end
            end,
            {description = "move focused client to tag #"..i + tag_rowlen, group = "tag"}),

        -- Toggle tag on focused client.
        awful.key({ env.mod1, ctrl, shift }, "#" .. i + 9,
            function ()
                if client.focus then
                    local tag = client.focus.screen.tags[i]
                    if tag then
                        client.focus:toggle_tag(tag)
                    end
                end
            end,
            {description = "toggle focused client on tag #" .. i, group = "tag"}),
        awful.key({ env.mod1, ctrl, shift }, "#" .. i + 9,
            function ()
                if client.focus then
                    local tag = client.focus.screen.tags[i + tag_rowlen]
                    if tag then
                        client.focus:toggle_tag(tag)
                    end
                end
            end,
            {description = "toggle focused client on tag #" .. i + tag_rowlen, group = "tag"})
    )
end

-- window moving/swapping

keys.globalkeys = gears.table.join(keys.globalkeys,
	-- move focus in a direction
	awful.key({ env.mod1 }, "j",
		function()
		    awful.client.focus.bydirection("down")
		    if client.focus then client.focus:raise() end
		end,
		{description = "focus down", group = "client"}),
	awful.key({ env.mod1 }, "k",
		function()
		    awful.client.focus.bydirection("up")
		    if client.focus then client.focus:raise() end
		end,
		{description = "focus up", group = "client"}),
	awful.key({ env.mod1 }, "h",
		function()
		    awful.client.focus.bydirection("left")
		    if client.focus then client.focus:raise() end
		end,
		{description = "focus left", group = "client"}),
	awful.key({ env.mod1 }, "l",
		function()
		    awful.client.focus.bydirection("right")
		    if client.focus then client.focus:raise() end
		end,
		{description = "focus right", group = "client"}),

    	-- Focus client by index (cycle through clients)
    	-- Double tap: choose client with rofi
	awful.key({ env.mod1 }, "Tab",
		function ()
		    awful.client.focus.byidx( 1)
		end,
		{description = "focus next by index", group = "client"}),
	awful.key({ env.mod1, shift }, "Tab",
		function ()
		    awful.client.focus.byidx(-1)
		end,
		{description = "focus previous by index", group = "client"}),

	-- Urgent or Undo:
	-- Jump to urgent client or (if there is no such client) go back
	-- to the last tag
	awful.key({ env.mod1 }, "u",
		function ()
		    uc = awful.client.urgent.get()
		    -- If there is no urgent client, go back to last tag
		    if uc == nil then
			awful.tag.history.restore()
		    else
			awful.client.urgent.jumpto()
		    end
		end,
		{description = "jump to urgent client", group = "client"})

)

keys.globalkeys = gears.table.join(keys.globalkeys,
	-- Screenshot clipboard
	awful.key({ env.mod1 }, "c",
		function ()
		   awful.spawn("escrotum -sC")
		end,
		{description = "Take a screenshot of an area and save it to the clipboard.", group = "util"}),
	-- Screenshot
	awful.key({ env.mod1, shift }, "c",
		function ()
		   awful.spawn("escrotum -s")
		end,
		{description = "Take a screenshot of an area and save it in $HOME.", group = "util"}))


return keys
