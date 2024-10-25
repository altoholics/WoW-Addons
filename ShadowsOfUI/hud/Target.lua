local _, ns = ...
local ui = ns.ui
local Class = ns.lua.Class
local Frame, Label = ui.Frame, ui.Label
local Player = ns.wow.Player
local AbbreviateNumbers = ns.lua.AbbreviateNumbers

local Target = Class(Frame, function(self)
  self.hp = Label:new{
    parent = self,
    text = "",
    font = "GameFontHighlight",
    position = {
      Center = {0, 8},
    },
    alpha = 0.8,
  }
  self.hpPcnt = Label:new{
    parent = self,
    text = "",
    font = "GameFontHighlight",
    position = {
      Center = {0, -8},
    },
    alpha = 0.8,
  }

  self:PLAYER_TARGET_CHANGED()
end, {
  name = "$parentTarget",
  alpha = 0.9,
  position = {
    Center = {120, -20},
    Width = 1,
    Height = 1,
  },
  events = {"PLAYER_TARGET_CHANGED"},
  unitEvents = {
    UNIT_HEALTH = {"target"},
  },
})
ns.Target = Target

function Target:PLAYER_TARGET_CHANGED()
  local t = Player:HasTarget()
  self:SetShown(t)
  if t then self:UNIT_HEALTH() end
end

function Target:UNIT_HEALTH()
  local hp = UnitHealth("target")
  local max = UnitHealthMax("player")
  local pcnt = math.floor(100 * (hp / max)).."%"
  self.hp:Text(AbbreviateNumbers(hp))
  self.hpPcnt:Text(pcnt)
end
