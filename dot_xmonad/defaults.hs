

{-# OPTIONS -fno-warn-missing-signatures #-}
-----------------------------------------------------------------------------
-- |
-- Module      :  XMonad.Config
-- Copyright   :  (c) Spencer Janssen 2007
-- License     :  BSD3-style (see LICENSE)
--
-- Maintainer  :  dons@galois.com
-- Stability   :  stable
-- Portability :  portable
--
-- This module specifies the default configuration values for xmonad.
--
-- DO NOT MODIFY THIS FILE!  It won't work.  You may configure xmonad
-- by providing your own @~\/.xmonad\/xmonad.hs@ that overrides
-- specific fields in 'defaultConfig'.  For a starting point, you can
-- copy the @xmonad.hs@ found in the @man@ directory, or look at
-- examples on the xmonad wiki.
--
------------------------------------------------------------------------

module XMonad.Config (defaultConfig) where

--
-- Useful imports
--
import XMonad.Core as XMonad hiding
    (workspaces,manageHook,keys,logHook,startupHook,borderWidth,mouseBindings
    ,layoutHook,modMask,terminal,normalBorderColor,focusedBorderColor,focusFollowsMouse
    ,handleEventHook,clickJustFocuses)
import qualified XMonad.Core as XMonad
    (workspaces,manageHook,keys,logHook,startupHook,borderWidth,mouseBindings
    ,layoutHook,modMask,terminal,normalBorderColor,focusedBorderColor,focusFollowsMouse
    ,handleEventHook,clickJustFocuses)

import XMonad.Layout
import XMonad.Operations
import XMonad.ManageHook
import qualified XMonad.StackSet as W
import Data.Bits ((.|.))
import Data.Monoid
import qualified Data.Map as M
import System.Exit
import Graphics.X11.Xlib
import Graphics.X11.Xlib.Extras

-- | The default number of workspaces (virtual screens) and their names.
-- By default we use numeric strings, but any string may be used as a
-- workspace name. The number of workspaces is determined by the length
-- of this list.
--
-- A tagging example:
--
-- > workspaces = ["web", "irc", "code" ] ++ map show [4..9]
--
workspaces :: [WorkspaceId]
workspaces = map show [1 .. 9 :: Int]

-- | modMask lets you specify which modkey you want to use. The default
-- is mod1Mask ("left alt").  You may also consider using mod3Mask
-- ("right alt"), which does not conflict with emacs keybindings. The
-- "windows key" is usually mod4Mask.
--
defaultModMask :: KeyMask
defaultModMask = mod1Mask

-- | Width of the window border in pixels.
--
borderWidth :: Dimension
borderWidth = 1

-- | Border colors for unfocused and focused windows, respectively.
--
normalBorderColor, focusedBorderColor :: String
normalBorderColor  = "gray" -- "#dddddd"
focusedBorderColor = "red"  -- "#ff0000" don't use hex, not <24 bit safe

------------------------------------------------------------------------
-- Window rules

-- | Execute arbitrary actions and WindowSet manipulations when managing
-- a new window. You can use this to, for example, always float a
-- particular program, or have a client always appear on a particular
-- workspace.
--
-- To find the property name associated with a program, use
--  xprop | grep WM_CLASS
-- and click on the client you're interested in.
--
manageHook :: ManageHook
manageHook = composeAll
                [ className =? "MPlayer"        --> doFloat
                , className =? "Gimp"           --> doFloat ]

------------------------------------------------------------------------
-- Logging

-- | Perform an arbitrary action on each internal state change or X event.
-- Examples include:
--
--      * do nothing
--
--      * log the state to stdout
--
-- See the 'DynamicLog' extension for examples.
--
logHook :: X ()
logHook = return ()

------------------------------------------------------------------------
-- Event handling

-- | Defines a custom handler function for X Events. The function should
-- return (All True) if the default handler is to be run afterwards.
-- To combine event hooks, use mappend or mconcat from Data.Monoid.
handleEventHook :: Event -> X All
handleEventHook _ = return (All True)

-- | Perform an arbitrary action at xmonad startup.
startupHook :: X ()
startupHook = return ()

------------------------------------------------------------------------
-- Key bindings:
-- | Mouse bindings: default actions bound to mouse events
mouseBindings :: XConfig Layout -> M.Map (KeyMask, Button) (Window -> X ())
mouseBindings (XConfig {XMonad.modMask = modMask}) = M.fromList
    -- mod-button1 %! Set the window to floating mode and move by dragging
    [ ((modMask, button1), \w -> focus w >> mouseMoveWindow w
                                          >> windows W.shiftMaster)
    -- mod-button2 %! Raise the window to the top of the stack
    , ((modMask, button2), windows . (W.shiftMaster .) . W.focusWindow)
    -- mod-button3 %! Set the window to floating mode and resize by dragging
    , ((modMask, button3), \w -> focus w >> mouseResizeWindow w
                                         >> windows W.shiftMaster)
    -- you may also bind events to the mouse scroll wheel (button4 and button5)
    ]

-- | The default set of configuration values itself
defaultConfig = XConfig
    { XMonad.borderWidth        = borderWidth
    , XMonad.workspaces         = workspaces
    , XMonad.layoutHook         = layout
    , XMonad.terminal           = terminal
    , XMonad.normalBorderColor  = normalBorderColor
    , XMonad.focusedBorderColor = focusedBorderColor
    , XMonad.modMask            = defaultModMask
    , XMonad.keys               = keys
    , XMonad.logHook            = logHook
    , XMonad.startupHook        = startupHook
    , XMonad.mouseBindings      = mouseBindings
    , XMonad.manageHook         = manageHook
    , XMonad.handleEventHook    = handleEventHook
    , XMonad.focusFollowsMouse  = focusFollowsMouse
    , XMonad.clickJustFocuses       = clickJustFocuses
    }

