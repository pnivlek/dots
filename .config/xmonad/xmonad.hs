import System.IO
import System.Exit

import           XMonad

import           XMonad.Hooks.DynamicLog
import           XMonad.Hooks.ManageDocks
import           XMonad.Hooks.ManageHelpers
import           XMonad.Hooks.StatusBar
import           XMonad.Hooks.StatusBar.PP

import           XMonad.Util.EZConfig
import           XMonad.Util.Loggers
import           XMonad.Util.Run
import           XMonad.Util.SpawnOnce
import           XMonad.Util.Ungrab

import           XMonad.Layout.NoBorders
import           XMonad.Layout.BinarySpacePartition
import           XMonad.Layout.Spacing

import           XMonad.Hooks.EwmhDesktops
import           XMonad.Hooks.SetWMName


myWorkspaces :: [String]
myWorkspaces = [ "main", "dev1", "dev2", "edu1", "edu2", "msc1", "msc2", "chat" ]

myManageHook :: ManageHook
myManageHook =
  composeAll [className =? "Gimp" --> doFloat, isDialog --> doFloat]

-- lessBorders OnlyFloat because sometimes I plug into tv.
myLayout = spacing 4 $ avoidStruts $ lessBorders OnlyFloat $ tiled ||| Mirror tiled ||| Full ||| emptyBSP
 where
  tiled    = Tall nmaster delta ratio
  nmaster  = 1      -- Default number of windows in the master pane
  ratio    = 1 / 2    -- Default proportion of screen occupied by master pane
  delta    = 3 / 100  -- Percent of screen to increment by when resizing panes

myStartupHook :: X ()
myStartupHook = do
  setWMName "LG3D"
  spawnOnce "urxvtd -q -f -o"
  spawnOnce "dunst -config ~/.config/dunst/dunstrc"
  spawnOnce "picom -I 0.085 -O 0.085"
  spawn "hsetroot -cover /home/yack/pic/wal/crshd.png -brightness 0"
  spawn "setxkbmap -option ctrl:nocaps"
 --  spawn "kmonad ~/.config/kmonad"

myKeysP :: [(String, X ())]
myKeysP =
  -- Basic commands
  [ ("M-S-<Return>", spawn "urxvtc")
  , ("M-S-x", spawn "betterlockscreen -l")
  , ("M-p", spawn "dmenu_run -fn 'PragmataPro for Powerline' -nb '#151515' -nf '#D7D0C7' -sb '#E84F4F' -sf '#151515'")
  , ("M-b", spawn "pkill xmobar")
  , ("M-S-q", kill)
  , ("M-S-<Escape>", io (exitWith ExitSuccess))
  -- Screenshots
  , ("M-S-s", spawn "maim -s -u | xclip -selection clipboard -t image/png -i")
  , ( "M-C-s"
    , spawn
      "maim -su > /tmp/maim.png && mv /tmp/maim.png ~/pic/scr/$(ls ~/pic/scr | dmenu).png"
    )
  -- Notifications
  , ("M-C-<Space>", spawn "dunstctl close")
  , ("M-C-`", spawn "dunstctl history-pop")
  -- Password
  , ("M-v", spawn "passmenu -l 5")
  , ("M-S-v", spawn "passmenu --type -l 5")
  -- Function Keys
  , ("<XF86AudioMute>"        , spawn "amixer sset 'Master' toggle")
  , ("<XF86AudioLowerVolume>" , spawn "amixer sset 'Master' 5%-")
  , ("<XF86AudioRaiseVolume>" , spawn "amixer sset 'Master' 5%+")
  , ("<XF86AudioMicMute>"     , spawn "amixer sset 'Capture' toggle")
  , ("<XF86MonBrightnessUp>"  , spawn "light -A 10")
  , ("<XF86MonBrightnessDown>", spawn "light -U 10")
  -- Multi monitor. If HDMI-1 isn't attached xrandr will just detect that and ignore HDMI-1.
  , ("<XF86Display>"          , spawn "xrandr --output eDP-1 --primary --auto --output HDMI-1 --auto --left-of eDP-1")
  ]

main :: IO ()
main = do
  -- Status bar
  xmproc <- spawnPipe "xmobar /home/yack/.config/xmonad/xmobar"
  -- xmonad
  xmonad
    .                 ewmhFullscreen
    .                 ewmh
    $                 docks
    $                 def
                        { modMask         = mod4Mask      -- Rebind Mod to the Super key
                        , workspaces      = myWorkspaces
                        , normalBorderColor = "#7DC1CF"
                        , focusedBorderColor = "#E84F4F"
                        , layoutHook      = myLayout      -- Use custom layouts
                        , manageHook      = manageDocks <+> myManageHook -- Match on certain windows
                        , startupHook     = myStartupHook -- Startup programs
                        , logHook         = dynamicLogWithPP xmobarPP
                                              { ppOutput = hPutStrLn xmproc
                                              , ppCurrent = xmobarColor "#D23D3D" "" . wrap "[" "]"  -- Current workspace in xmobar
                                              , ppTitle = xmobarColor "#dddddd" "" . shorten 40 -- Title of active window in xmobar
                                              , ppSep = "<fc=#7DC1CF> | </fc>"                  -- Separators in xmobar
                                              , ppUrgent = xmobarColor "#E84F4F" "" . wrap "!" "!"  -- Urgent workspace
                                              , ppOrder = \(ws : l : t : ex) -> [ws, l] ++ ex -- ++ [t]
                                              }
                        }
    `additionalKeysP` myKeysP
