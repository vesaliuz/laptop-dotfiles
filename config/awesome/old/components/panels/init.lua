--      ██████╗  █████╗ ███╗   ██╗███████╗██╗     ███████╗
--      ██╔══██╗██╔══██╗████╗  ██║██╔════╝██║     ██╔════╝
--      ██████╔╝███████║██╔██╗ ██║█████╗  ██║     ███████╗
--      ██╔═══╝ ██╔══██║██║╚██╗██║██╔══╝  ██║     ╚════██║
--      ██║     ██║  ██║██║ ╚████║███████╗███████╗███████║
--      ╚═╝     ╚═╝  ╚═╝╚═╝  ╚═══╝╚══════╝╚══════╝╚══════╝

-- ===================================================================
-- Imports
-- ===================================================================


local awful = require('awful')
local top_panel = require('components.panels.top-panel')
local left_panel = require('components.panels.left-panel')


-- ===================================================================
-- Initialization & Functionality
-- ===================================================================


-- Create a wibox for each screen and add it
screen.connect_signal("request::desktop_decoration", function(s)
  if s.index == 1 then
      -- Create the left bar
      s.left_panel = left_panel(s)
      -- Create the Top bar
      s.top_panel = top_panel(s)
    else
      -- Just create the top bar on non primary displays
      s.top_panel = top_panel(s)
    end
end)

-- Hide bars when app go fullscreen
function updateBarsVisibility()
  for s in screen do
    if s.selected_tag then
      local fullscreen = s.selected_tag.fullscreenMode

      -- make top / left bar invisible if fullscreen
      s.top_panel.visible = not fullscreen
      if s.left_panel then
        s.left_panel.visible = not fullscreen
      end
    end
  end
end

tag.connect_signal(
  'property::selected',
  function(t)
    updateBarsVisibility()
  end
)

client.connect_signal(
  'property::fullscreen',
  function(c)
    if c.first_tag then
      c.first_tag.fullscreenMode = c.fullscreen
    end
    updateBarsVisibility()
  end
)

client.connect_signal(
  'property::maximized',
  function(c)
    if c.first_tag then
      maximizeLeftPanel(c.maximized)
    end
  end
)

client.connect_signal(
  'unmanage',
  function(c)
    if c.fullscreen then
      c.screen.selected_tag.fullscreenMode = false
      updateBarsVisibility()
    end
    if c.maximized then
      maximizeLeftPanel(false)
    end
  end
)

-- maximize left panel if layout is set to max
tag.connect_signal(
  'property::layout',
  function(t)
    local currentLayout = awful.tag.getproperty(t, 'layout')
    if (currentLayout == awful.layout.suit.max) then
      maximizeLeftPanel(true)
    else
      maximizeLeftPanel(false)
    end
  end
)