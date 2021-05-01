-- Base
import XMonad
import System.Exit (exitSuccess)
import qualified XMonad.StackSet as W

-- Actions
import XMonad.Actions.CopyWindow (kill1, killAllOtherCopies, copyToAll, copy)
import qualified XMonad.Actions.CycleWS as WS
import XMonad.Actions.Promote
import XMonad.Actions.RotSlaves (rotSlavesDown, rotAllDown)
import XMonad.Actions.WindowGo (runOrRaise)
import XMonad.Actions.WithAll (sinkAll, killAll)
import qualified XMonad.Actions.Search as S

-- Data
import Data.Char (isSpace)
import Data.List
import Data.Monoid
import qualified Data.Map as M

-- Hooks
import XMonad.Hooks.DynamicLog (dynamicLogWithPP, wrap, xmobarPP, xmobarColor, shorten, PP(..))
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks (avoidStruts, docksEventHook, manageDocks, ToggleStruts(..))
import XMonad.Hooks.ManageHelpers (isFullscreen, doFullFloat)
import XMonad.Hooks.SetWMName

-- Layouts
import XMonad.Layout.GridVariants (Grid(Grid))
import XMonad.Layout.SimplestFloat
import XMonad.Layout.ResizableTile
import XMonad.Layout.ThreeColumns
import XMonad.Layout.ResizableThreeColumns

-- Layouts modifiers
import XMonad.Layout.LayoutModifier
import XMonad.Layout.LimitWindows (limitWindows, increaseLimit, decreaseLimit)
import XMonad.Layout.MultiToggle (mkToggle, single, EOT(EOT), (??))
import XMonad.Layout.MultiToggle.Instances (StdTransformers(NBFULL, MIRROR, NOBORDERS))
import XMonad.Layout.Renamed
import XMonad.Layout.Spacing
import XMonad.Layout.PerWorkspace
import qualified XMonad.Layout.ToggleLayouts as T (toggleLayouts, ToggleLayout(Toggle))
import qualified XMonad.Layout.MultiToggle as MT (Toggle(..))

-- Prompt
import XMonad.Prompt
import XMonad.Prompt.Input
import XMonad.Prompt.Man
import XMonad.Prompt.Pass
import XMonad.Prompt.Shell
import XMonad.Prompt.Ssh
import XMonad.Prompt.XMonad
import XMonad.Prompt.RunOrRaise
import XMonad.Prompt.Window
import Control.Arrow (first)

-- Utilities
import XMonad.Util.EZConfig (additionalKeysP)
import XMonad.Util.NamedScratchpad
import XMonad.Util.Run
import XMonad.Util.SpawnOnce

myFont :: String
myFont = "xft:Hack Nerd Font:bold:pixelsize=13"

myModMask :: KeyMask
myModMask = mod4Mask       -- Sets modkey to super/windows key

myTerminal :: String
myTerminal = "st"          -- Sets default terminal

myBorderWidth :: Dimension
myBorderWidth = 3          -- Sets border width for windows

myNormColor :: String
myNormColor   = "#2c2c2e"  -- Border color of normal windows

myFocusColor :: String
myFocusColor  = "#008080"  -- Border color of focused windows

altMask :: KeyMask
altMask = mod1Mask         -- Setting this for use in xprompts

windowCount :: X (Maybe String)
windowCount = gets $ Just . show . length . W.integrate' . W.stack . W.workspace . W.current . windowset

myStartupHook :: X ()
myStartupHook = do
          spawnOnce "nitrogen --set-zoom-fill /home/mashy/Pictures/solar2.jpg"
          spawnOnce "picom -b"
          spawnOnce "xmodmap /home/mashy/.Xmodmap"
          spawnOnce "/usr/sbin/emacs --daemon &"
          setWMName "LG3D"

-- Prompt parameters (fonts, colours, soze, location, features etc.)
myXPConfig :: XPConfig
myXPConfig = def
     { font                = "xft:Hack Nerd Font:size=9"
     , bgColor             = "#292d3e"
     , fgColor             = "#d0d0d0"
     , bgHLight            = "#c792ea"
     , fgHLight            = "#000000"
     , borderColor         = "#535974"
     , promptBorderWidth   = 0
     , promptKeymap        = myXPKeymap
       -- , position            = Top
     , position            = CenteredAt { xpCenterY = 0.3, xpWidth = 0.3 }
     , height              = 20
     , historySize         = 256
     , historyFilter       = id
     , defaultText         = []
     , autoComplete        = Just 100000  -- set Just 100000 for .1 sec
     , showCompletionOnTab = True
     , searchPredicate     = isPrefixOf
     , alwaysHighlight     = True
     , maxComplRows        = Nothing      -- set to Just 5 for 5 rows
     }

-- The same config minus the autocomplete feature for prompts where it is not desirable.
myXPConfig' :: XPConfig
myXPConfig' = myXPConfig
     { autoComplete = Nothing
     }

-- A list of all of the standard Xmonad prompts
promptList :: [(String, XPConfig -> X ())]
promptList = [ ("m", manPrompt)          -- manpages prompt
             , ("p", passPrompt)         -- get passwords (requires 'pass')
             , ("g", passGeneratePrompt) -- generate passwords (requires 'pass')
             , ("r", runOrRaisePrompt)   -- runs or focus on a (gui) program
             , ("s", sshPrompt)          -- ssh prompt
             , ("x", xmonadPrompt)       -- xmonad prompt
             ]

promptList' :: [(String, XPConfig -> String -> X (), String)]
promptList' = [ ("c", calcPrompt, "qalc")         -- requires qalculate-gtk
              ]

calcPrompt c ans =
    inputPrompt c (trim ans) ?+ \input ->
        liftIO(runProcessWithInput "qalc" [input] "") >>= calcPrompt c
    where
        trim  = f . f
            where f = reverse . dropWhile isSpace


-- Keymaps (emacs-like key bindings)
myXPKeymap :: M.Map (KeyMask,KeySym) (XP ())
myXPKeymap = M.fromList $
     map (first $ (,) controlMask)   -- control + <key>
     [ (xK_z, killBefore)            -- kill line backwards
     , (xK_k, killAfter)             -- kill line fowards
     , (xK_a, startOfLine)           -- move to the beginning of the line
     , (xK_e, endOfLine)             -- move to the end of the line
     , (xK_m, deleteString Next)     -- delete a character foward
     , (xK_b, moveCursor Prev)       -- move cursor forward
     , (xK_f, moveCursor Next)       -- move cursor backward
     , (xK_BackSpace, killWord Prev) -- kill the previous word
     , (xK_y, pasteString)           -- paste a string
     , (xK_g, quit)                  -- quit out of prompt
     , (xK_bracketleft, quit)
     ]
     ++
     map (first $ (,) altMask)       -- meta key + <key>
     [ (xK_BackSpace, killWord Prev) -- kill the prev word
     , (xK_f, moveWord Next)         -- move a word forward
     , (xK_b, moveWord Prev)         -- move a word backward
     , (xK_d, killWord Next)         -- kill the next word
     , (xK_n, moveHistory W.focusUp')   -- move up thru history
     , (xK_p, moveHistory W.focusDown') -- move down thru history
     ]
     ++
     map (first $ (,) 0) -- <key>
     [ (xK_Return, setSuccess True >> setDone True)
     , (xK_KP_Enter, setSuccess True >> setDone True)
     , (xK_BackSpace, deleteString Prev)
     , (xK_Delete, deleteString Next)
     , (xK_Left, moveCursor Prev)
     , (xK_Right, moveCursor Next)
     , (xK_Home, startOfLine)
     , (xK_End, endOfLine)
     , (xK_Down, moveHistory W.focusUp')
     , (xK_Up, moveHistory W.focusDown')
     , (xK_Escape, quit)
     ]

-- Add additional search engines.
archwiki, ebay, news, reddit, amazon, scholar :: S.SearchEngine
archwiki = S.searchEngine "archwiki" "https://wiki.archlinux.org/index.php?search="
ebay     = S.searchEngine "ebay" "https://www.ebay.com/sch/i.html?_nkw="
news     = S.searchEngine "news" "https://news.google.com/search?q="
reddit   = S.searchEngine "reddit" "https://www.reddit.com/search/?q="
amazon   = S.searchEngine "amazon" "https://www.amazon.co.uk/s?k="
scholar  = S.searchEngine "scholar" "https://scholar.google.co.uk/scholar?hl=en&as_sdt=0%2C5&q="

-- List all the search engines and give them a key
searchList :: [(String, S.SearchEngine)]
searchList = [ ("a", archwiki)
             , ("c", scholar)
             , ("d", S.duckduckgo)
             , ("e", ebay)
             , ("g", S.google)
             , ("h", S.hoogle)
             , ("n", news)
             , ("r", reddit)
             , ("s", S.stackage)
             , ("v", S.vocabulary)
             , ("w", S.wikipedia)
             , ("y", S.youtube)
             , ("z", amazon)
             ]

myKeys :: [(String, X ())]
myKeys =
     [ -- Xmonad
       ("M-C-r", spawn "xmonad --recompile && xmonad --restart") -- Recompiles xmonad
     , ("M-S-r", spawn "xmonad --restart")                       -- Restarts xmonad
     , ("M-C-S-q", io exitSuccess)                               -- Quits xmonad

       -- Open my preferred terminal
     , ("M-<Return>", spawn (myTerminal))
     , ("M-t", spawn "termite")

       -- Run Prompt
     , ("M-S-<Return>", shellPrompt myXPConfig')   --- Shell Prompt
     -- , ("<XF86MenuKB> r", shellPrompt myXPConfig')  -- Shell Prompt

       -- Dmenu
     , ("M-d", spawn "/home/mashy/.scripts/dmenu_recency.sh")   -- Demenu recency (adapted from Manjaro i3)
     , ("<XF86Explorer> d", spawn "/home/mashy/.scripts/dmenu_recency.sh")   -- Demenu recency (adapted from Manjaro i3)
     , ("<XF86Explorer> c", spawn "/home/mashy/.scripts/dmenu_scripts.sh")   -- Dmenu launch scripts
     , ("<XF86Explorer> q", spawn "/home/mashy/.scripts/dmenu_power.sh")     -- Dmenu power menu

       -- Windows
     , ("M-q", kill1)      -- Kill the currently focused client
     , ("M-S-q", killAll)  -- Kill all windows in current layout

       -- Floating windows
     , ("M-f", sendMessage (T.Toggle "floats"))       -- Toggles my 'floats' layout
     , ("M-<Delete>", withFocused $ windows . W.sink) -- Push floating window back to tile
     , ("M-S-<Delete>", sinkAll)                      -- Push ALL floating windows to tile

       -- Windows navigation
     , ("M-m", windows W.focusMaster)     -- Move focus to the master window
     , ("M-c", windows copyToAll)         -- Copies focused window to all workspaces
     , ("M-j", windows W.focusDown)       -- Move focus to the next window
     , ("M-k", windows W.focusUp)         -- Move focus to the prev window
     , ("M-S-m", windows W.swapMaster)    -- Swap the focused window and the master window
     , ("M-S-j", windows W.swapDown)      -- Swap focused window with next window
     , ("M-S-k", windows W.swapUp)        -- Swap focused window with prev window
     , ("M-<Backspace>", promote)         -- Moves focused window to master, others maintain order
     , ("C-S-<Tab>", rotSlavesDown)       -- Rotate all windows except master and keep focus in place
     , ("M1-S-<Tab>", rotAllDown)         -- Rotate all the windows in the current stack
     , ("M-C-c", killAllOtherCopies)      -- Delete all copies of window

       -- Layouts
     , ("M-<Tab>", sendMessage NextLayout)               -- Switch to next layout
     , ("M-<Space>", sendMessage (MT.Toggle NBFULL) >> sendMessage ToggleStruts) -- Toggles noborder/full
     , ("M-S-<Space>", sendMessage ToggleStruts)         -- Toggles struts
     , ("M-S-n", sendMessage $ MT.Toggle NOBORDERS)      -- Toggles noborder
     , ("M-<KP_Multiply>", sendMessage (IncMasterN 1))   -- Increase number of clients in master pane
     , ("M-<KP_Divide>", sendMessage (IncMasterN (-1)))  -- Decrease number of clients in master pane
     , ("M-S-<KP_Multiply>", increaseLimit)              -- Increase number of windows
     , ("M-S-<KP_Divide>", decreaseLimit)                -- Decrease number of windows
     , ("M-<End>", WS.nextWS)                            -- Increase number of windows
     , ("M-<Home>", WS.prevWS)                           -- Decrease number of windows

       -- Resize windows
     , ("M-h", sendMessage Shrink)                       -- Shrink horiz window width
     , ("M-l", sendMessage Expand)                       -- Expand horiz window width
     , ("M-S-h", sendMessage MirrorShrink)               -- Shrink vert window width (only works with resizable layouts)
     , ("M-S-l", sendMessage MirrorExpand)               -- Expand vert window width (only works with resizable layouts)

       -- Applications (Super(+Ctrl)+Key)
     , ("M-e", spawn "emacsclient -c -a ''")         -- Editor (emacs)
     , ("M-r", runInTerm "" "ranger")                -- File manager
     , ("M-C-a", spawn ("pavucontrol"))              -- Audio control
     , ("M-C-b", spawn ("firefox"))                  -- Browser
     , ("M-C-S-b", spawn ("brave"))                  -- Browser
     , ("M-C-e", spawn ("termite" ++ " -e neomutt")) -- Email
     , ("M-C-v", spawn ("termite" ++ " -e vis"))     -- Audio visualiser
     , ("M-C-m", spawn ("termite" ++ " -e ncmpcpp")) -- Music player
     , ("M-C-t", spawn ("teams"))                    -- MS teams (thanks work!!!)
     , ("M-C-d", spawn ("discord"))                  -- Because sometimes you wanna talk about keyboards and emacs

       -- Multimedia Keys
     , ("<XF86AudioLowerVolume>", spawn "pactl set-sink-volume @DEFAULT_SINK@ -1%")
     , ("<XF86AudioRaiseVolume>", spawn "pactl set-sink-volume @DEFAULT_SINK@ +1%")
     , ("S-<XF86AudioLowerVolume>", spawn "pactl set-sink-volume @DEFAULT_SINK@ -5%")
     , ("S-<XF86AudioRaiseVolume>", spawn "pactl set-sink-volume @DEFAULT_SINK@ +5%")

       -- Print screen. Requires scrot.
     , ("<Print>", spawn "scrot '%Y-%m-%d-%s_screenshot_$wx$h.jpg' -e 'mv $f ~/Pictures/' ")

       -- Scratchpads
     , ("M-s t", namedScratchpadAction myScratchPads "term")
     , ("M-s m", namedScratchpadAction myScratchPads "music")
     , ("M-s e", namedScratchpadAction myScratchPads "mail")
     , ("M-s b", namedScratchpadAction myScratchPads "bt")
     , ("M-s p", namedScratchpadAction myScratchPads "audio")

     , ("<XF86Explorer> r t", prompt ("termite" ++ " -e") myXPConfig)   -- for cli
     , ("<XF86Explorer> r g", runOrRaisePrompt            myXPConfig)   -- for gui
     , ("<XF86Explorer> w b", windowPrompt myXPConfig Bring allWindows)
     , ("<XF86Explorer> w g", windowPrompt myXPConfig Goto allWindows)
     ]

  -- Appending search engines to keybindings list
  ++ [("<XF86Explorer> s " ++ k, S.promptSearch myXPConfig' f) | (k,f) <- searchList ]
  ++ [("M-S-s "            ++ k, S.selectSearch f) | (k,f) <- searchList ]
  ++ [("<XF86Explorer> p " ++ k, f myXPConfig') | (k,f) <- promptList ]
  ++ [("<XF86Explorer> p " ++ k, f myXPConfig' g) | (k,f,g) <- promptList' ]

xmobarEscape :: String -> String
xmobarEscape = concatMap doubleLts
  where
        doubleLts '<' = "<<"
        doubleLts x   = [x]

myWorkspaces :: [String]
myWorkspaces = clickable . map xmobarEscape
               $ ["main", "dev1", "dev2", "dev3", "files", "chat", "write", "edit", "watch"]
  where
        clickable l = [ "<action=xdotool key super+" ++ show n ++ ">" ++ ws ++ "</action>" |
                      (i,ws) <- zip [1..9] l,
                      let n = i ]

myManageHook :: XMonad.Query (Data.Monoid.Endo WindowSet)
myManageHook = composeAll
               [ className =? "vlc"       --> doShift ( myWorkspaces !! 8)
               , className =? "ParaView"  --> doShift ( myWorkspaces !! 2)
               , className =? "Gimp"      --> doShift ( myWorkspaces !! 7)
               , className =? "discord"   --> doShift ( myWorkspaces !! 5) -- 'chat'
               , className =? "discord"   --> doFloat
               , className =? "Microsoft Teams - Preview" --> doShift ( myWorkspaces !! 5) -- 'chat'
               , className =? "Microsoft Teams - Preview" --> doFloat
               , (className =? "firefox" <&&> resource =? "Dialog") --> doFloat  -- Float Firefox Dialog
               ] <+> namedScratchpadManageHook myScratchPads

-- The spacingRaw module adds a configurable amount of space around windows.
mySpacing :: Integer -> l a -> XMonad.Layout.LayoutModifier.ModifiedLayout Spacing l a
mySpacing i = spacingRaw False (Border i i i i) True (Border i i i i) True

-- A variation of the above except no borders are applied if fewer than two
-- windows, so that a single window has no gaps.
mySpacing' :: Integer -> l a -> XMonad.Layout.LayoutModifier.ModifiedLayout Spacing l a
mySpacing' i = spacingRaw True (Border i i i i) True (Border i i i i) True

-- Defining some layouts.
threeCol = renamed [Replace "threeCol"]
           $ limitWindows 9
           $ mySpacing' 6
           $ ResizableThreeColMid 1 (4/100) (5/12) []
grid     = renamed [Replace "grid"]
           $ limitWindows 12
           $ mySpacing 6
           $ mkToggle (single MIRROR)
           $ Grid (16/10)
floats   = renamed [Replace "floats"]
           $ limitWindows 20 simplestFloat
threeColDev = renamed [Replace "threeColDev"]
           $ limitWindows 10
           $ mySpacing' 6
           $ ResizableThreeColMid 2 (1/100) (5/8) [(19/10)]
-- tall     = renamed [Replace "tall"]
--            $ limitWindows 12
--            $ mySpacing 6
--            $ ResizableTall 1 (3/100) (1/2) []

-- The layout hook. onWorkspace spcifies the workspaces from the first
-- layout hook, myDevLHook, while all other workspaces use myDefaultLHook
myLayoutHook =  onWorkspaces [(myWorkspaces !! 1),(myWorkspaces !! 2)]
                myDevLHook myDefaultLHook
             where
               -- The layout hooks
               myDefaultLHook = avoidStruts $ T.toggleLayouts floats $
                 mkToggle (NBFULL ?? NOBORDERS ?? EOT) myDefaultLayout
               myDevLHook = avoidStruts $
                 mkToggle (NBFULL ?? NOBORDERS ?? EOT) myDevLayout
               -- The layouts
               myDefaultLayout = threeCol ||| floats
               myDevLayout = threeColDev ||| threeCol

myScratchPads = [
                  NS "term"  spawnTerm  findTerm  manageScratch
                , NS "music" spawnNcmp  findNcmp  manageScratch
                , NS "mail"  spawnEmail findEmail manageScratch
                , NS "bt"    spawnBT    findBT    manageScratch
                , NS "audio" spawnPavu  findPavu  manageScratch
                ]
                where
                  -- Terminal (st)
                  spawnTerm  = "st" ++ " -n scratchpad"
                  findTerm   = resource =? "scratchpad"
                  -- Music player (ncmpcpp)
                  -- Note that using termite requires to define the title with --title manually
                  spawnNcmp  = "termite -e ncmpcpp --title scramusic"
                  findNcmp   = title =? "scramusic"
                  -- Email (neomutt)
                  spawnEmail  = "termite -e neomutt --title scramail"
                  findEmail   = title =? "scramail"
                  -- Bluetooth manager (blueman)
                  spawnBT  = "blueman-manager"
                  findBT   = className =? "Blueman-manager"
                  -- Audio mixer (pulseaudio)
                  spawnPavu  = "pavucontrol"
                  findPavu   = className =? "Pavucontrol"
                  manageScratch = customFloating $ center 0.3 0.5
                    where center w h = W.RationalRect ((1 - w) / 2) ((1 - h) / 2) w h

main :: IO ()
main = do
    -- Launch xmobar
    xmproc <- spawnPipe "xmobar /home/mashy/.config/xmonad/xmobar"
    -- Launch ewmh desktop
    xmonad $ ewmh def
        { manageHook = ( isFullscreen --> doFullFloat ) <+> myManageHook
        , handleEventHook    = docksEventHook
        , modMask            = myModMask
        , terminal           = myTerminal
        , startupHook        = myStartupHook
        , layoutHook         = myLayoutHook
        , workspaces         = myWorkspaces
        , borderWidth        = myBorderWidth
        , normalBorderColor  = myNormColor
        , focusedBorderColor = myFocusColor
        , logHook            = dynamicLogWithPP xmobarPP
                               { ppOutput          = hPutStrLn xmproc
                               , ppCurrent         = xmobarColor "#f57900" "" . wrap "[" "]"  -- Current workspace in xmobar
                               , ppVisible         = xmobarColor "#f57900" ""                 -- Visible but not current workspace
                               , ppHidden          = xmobarColor "#ffc135" "" . wrap "*" ""   -- Hidden workspaces in xmobar
                               , ppHiddenNoWindows = xmobarColor "#16a085" ""                 -- Hidden workspaces (no windows)
                               , ppTitle           = xmobarColor "#b3afc2" "" . shorten 80    -- Title of active window in xmobar
                               , ppSep             =  "<fc=#666666> | </fc>"                  -- Separators in xmobar
                               , ppUrgent          = xmobarColor "#d81b5f" "" . wrap "!" "!"  -- Urgent workspace
                               , ppExtras          = [windowCount]                            -- # of windows current workspace
                               , ppOrder           = \(ws:l:t:ex) -> [ws,l]++ex++[t]
                               }
        } `additionalKeysP` myKeys
