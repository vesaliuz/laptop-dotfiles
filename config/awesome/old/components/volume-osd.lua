--      ██╗   ██╗ ██████╗ ██╗     ██╗   ██╗███╗   ███╗███████╗
--      ██║   ██║██╔═══██╗██║     ██║   ██║████╗ ████║██╔════╝
--      ██║   ██║██║   ██║██║     ██║   ██║██╔████╔██║█████╗  
--      ╚██╗ ██╔╝██║   ██║██║     ██║   ██║██║╚██╔╝██║██╔══╝  
--       ╚████╔╝ ╚██████╔╝███████╗╚██████╔╝██║ ╚═╝ ██║███████╗
--        ╚═══╝   ╚═════╝ ╚══════╝ ╚═════╝ ╚═╝     ╚═╝╚══════╝


-- ===================================================================
-- Imports
-- ===================================================================


local gears = require("gears")
local wibox = require("wibox")
local beautiful = require('beautiful')
local dpi = require('beautiful').xresources.apply_dpi
local vol_osd = require('widgets.volume-slider-osd')


-- ===================================================================
-- Add Volume Overlay to Each Screen
-- ===================================================================


screen.connect_signal("request::desktop_decoration", function(s)
  -- Create the box
  local offsetx = dpi(56)
  local offsety = dpi(300)

  volumeOverlay = wibox {
    visible = nil,
    screen = s,
    ontop = true,
    type = "normal",
    height = offsety,
    width = dpi(48),
    bg = "#00000000",
    x = s.geometry.width - offsetx,
    y = (s.geometry.height / 2) - (offsety / 2),
  }
  -- Put its items in a shaped container
  volumeOverlay:setup {
    -- Container
    {
      wibox.container.rotate(vol_osd, 'east'),
      layout = wibox.layout.fixed.vertical
    },
    -- The real background color
    bg = beautiful.bg_normal,
    -- The real, anti-aliased shape
    shape = gears.shape.rounded_rect,
    widget = wibox.container.background()
  }

  local hideOSD = gears.timer {
    timeout = 5,
    autostart = true,
    callback  = function()
      volumeOverlay.visible = false
    end
  }

  function toggleVolOSD(bool)
    volumeOverlay.visible = bool
    if bool then
      hideOSD:again()
      if toggleBriOSD ~= nil then
        toggleBriOSD(false)
      end
    else
      hideOSD:stop()
    end
  end
end)