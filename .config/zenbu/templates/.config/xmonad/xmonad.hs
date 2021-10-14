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
import           XMonad.Layout.Renamed
import           XMonad.Layout.ThreeColumns

import           XMonad.Hooks.EwmhDesktops
import           XMonad.Hooks.SetWMName


myWorkspaces :: [String]
myWorkspaces = [ "main", "dev1", "dev2", "edu1", "edu2", "chat", "msc1", "msc2" ]

myManageHook :: ManageHook
myManageHook =
  composeAll [className =? "Gimp" --> doFloat, isDialog --> doFloat]

-- lessBorders OnlyFloat because sometimes I plug into tv.
myLayout = avoidStruts $ lessBorders OnlyFloat $ tiled ||| Mirror tiled ||| Full ||| threeCol
 where
  threeCol = ThreeColMid nmaster delta ratio
  tiled    = Tall nmaster delta ratio
  nmaster  = 1      -- Default number of windows in the master pane
  ratio    = 1 / 2    -- Default proportion of screen occupied by master pane
  delta    = 3 / 100  -- Percent of screen to increment by when resizing panes

myStartupHook :: X ()
myStartupHook = do
  setWMName "LG3D"
  spawnOnce "urxvtd -q -f -o"
  spawn "hsetroot -cover {{wallpaper}}"
  spawn "setxkbmap -option ctrl:nocaps"
  spawn "kmonad ~/.config/kmonad"

myKeysP :: [(String, X ())]
myKeysP =
  -- Basic commands
  [ ("M-S-<Return>", spawn "urxvtc")
  , ("M-S-x", spawn "slock")
  , ("M-b", spawn "pkill xmobar")
  , ("M-S-q", kill)
  , ("M-S-<Escape>", io (exitWith ExitSuccess))
  -- Screenshots
  , ("M-S-s", spawn "maim -s -u | xclip -selection clipboard -t image/png -i")
  , ( "M-C-s"
    , spawn
      "maim -su > /tmp/maim.png && mv /tmp/maim.png ~/pic/scr/$(ls ~/pic/scr | dmenu).png"
    )
  -- Function Keys
  , ("<XF86AudioMute>"        , spawn "pactl set-sink-mute 0 toggle")
  , ("<XF86AudioLowerVolume>" , spawn "pactl set-sink-volume 0 -5%")
  , ("<XF86AudioRaiseVolume>" , spawn "pactl set-sink-volume 0 +5%")
  , ("<XF86AudioMicMute>"     , spawn "pactl set-source-mute 1 toggle")
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
                        , normalBorderColor = "{{ colors.blue.normal }}"
                        , focusedBorderColor = "{{ colors.red.normal }}"
                        , handleEventHook = docksEventHook
                        , layoutHook      = myLayout      -- Use custom layouts
                        , manageHook      = manageDocks <+> myManageHook -- Match on certain windows
                        , startupHook     = myStartupHook -- Startup programs
                        , logHook         = dynamicLogWithPP xmobarPP
                                              { ppOutput = hPutStrLn xmproc
                                              , ppCurrent = xmobarColor "{{colors.white.normal}}" "" . wrap "[" "]"  -- Current workspace in xmobar
                                              , ppVisible = xmobarColor "{{colors.green.normal}}" ""                 -- Visible but not current workspace
                                              , ppHidden = xmobarColor "{{colors.yellow.normal}}" "" . wrap "*" ""   -- Hidden workspaces in xmobar
                                              , ppHiddenNoWindows = xmobarColor "{{colors.blue.normal}}" ""                 -- Hidden workspaces (no windows)
                                              , ppTitle = xmobarColor "{{colors.white.normal}}" "" . shorten 40 -- Title of active window in xmobar
                                              , ppSep = "<fc={{colors.blue.normal}}> | </fc>"                  -- Separators in xmobar
                                              , ppUrgent = xmobarColor "{{colors.red.normal}}" "" . wrap "!" "!"  -- Urgent workspace
                                              , ppOrder = \(ws : l : t : ex) -> [ws, l] ++ ex -- ++ [t]
                                              }
                        }
    `additionalKeysP` myKeysP
