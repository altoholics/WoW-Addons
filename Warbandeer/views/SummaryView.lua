local _, ns = ...
-- luacheck: globals WeeklyRewardsFrame GameTooltip
local ui = ns.ui

local tinsert = ns.lua.tinsert
local Class, TableFrame = ns.lua.Class, ui.TableFrame

local function formatBestVaultRewardOption(o)
  if not o or o.best == 0 then return nil end
  local t
  if o.bestN > 1 then
    t = o.best.." x"..o.bestN
  else
    t = o.best
  end
  local lines = {}
  for i,n in pairs(o.counts) do
    tinsert(lines, i.." x"..n)
  end
  return {
    text = t,
    onClick = function()
      if not ns.wow.IsAddOnLoaded("Blizzard_WeeklyRewards") then ns.wow.LoadAddOn("Blizzard_WeeklyRewards") end
      WeeklyRewardsFrame:Show()
    end,
    onEnter = function(self)
      self.label:Color(1, 1, 1, 0.8)
      if #lines > 1 then
        GameTooltip:SetOwner(self.frame, "ANCHOR_BOTTOMRIGHT", -10, 10)
        GameTooltip:ClearLines()
        for _,l in ipairs(lines) do GameTooltip:AddLine(l, 1, 1, 1) end
        GameTooltip:Show()
      end
    end,
    onLeave = function(self)
      self.label:Color(1, 1, 1, 1)
      if #lines > 1 then
        GameTooltip:Hide()
      end
    end,
  }
end

local SummaryView = Class(TableFrame, function(self)
  self:hide()
  local toons = ns.api.GetAllCharacters() -- returns a copy
  -- sort by level, then ilvl, then name
  table.sort(toons, function(c1, c2)
    if c1.level ~= c2.level then return c1.level > c2.level end
    if c1.ilvl ~= c2.ilvl then return c1.ilvl > c2.ilvl end
    return c1.name > c2.name
  end)

  self.data = {}
  for _,t in pairs(toons) do
    tinsert(self.data, {
      t.name,
      t.level,
      t.ilvl,
      formatBestVaultRewardOption(t.greatVault),
    })
  end

  self:update()
end, {
  colInfo = {
    { name = "Character", width = 80, backdrop = {color = {0, 0, 0, 0}} },
    { name = "Level", width = 40, backdrop = {color = {0, 0, 0, 0}} },
    { name = "iLvl", width = 40, backdrop = {color = {0, 0, 0, 0}} },
    { name = "Vault", width = 50, backdrop = {color = {0, 0, 0, 0}} },
  },
})
ns.views.SummaryView = SummaryView
