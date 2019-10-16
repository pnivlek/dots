-------------------------------------------------
--               AwesomeWM Config              --
--                    env.lua  		       --
-------------------------------------------------

local env = {}

local theme_collection = {
    "blue",        -- 1 --
}

env.theme = theme_collection[1]

env.terminal = "termite"
env.quake_terminal = "tilda"
env.mod1 = "Mod4"
env.mod2 = "Mod1"
env.tag_num = 20
env.tag_groups = 2

return env
