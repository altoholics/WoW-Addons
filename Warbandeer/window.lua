local ADDON_NAME, ns = ...
local ui = ns.ui
local views = ns.views

-- set up the main addon window
local Class, TitleFrame = ns.lua.Class, ui.TitleFrame
local RaceGridView, SummaryView = views.RaceGridView, views.SummaryView

local MainWindow = Class(TitleFrame, function(self)
  -- add the contents
  self.views = {}
  self.views.raceGrid = RaceGridView:new{
    parent = self,
    position = {
      topLeft = {3, -27},
    },
  }
  self.views.raceGrid:hide()

  self.views.summary = SummaryView:new{
    parent = self,
    position = {
      topLeft = {3, -27},
    },
  }
  self.views.summary:hide()

  self:view("raceGrid")
end, {
  name = ADDON_NAME,
  title = ADDON_NAME,
  position = {
    center = {},
  },
  special = true,
})

function MainWindow:view(name)
  if self._view then self._view:hide() end
  self._view = self.views[name]
  self._view:show()

  self:width(self._view:width()  + 6)
  self:height(self._view:height() + 30)
end

function ns:Open()
  if not ns.MainWindow then
    ns.MainWindow = MainWindow:new{}
  end

  ns.MainWindow:show()
end

function ns:view(name)
  self:Open()
  ns.MainWindow:view(name)
end

function ns:CompartmentClick() -- buttonName = (LeftButton | RightButton | MiddleButton)
  self:Open()
end
