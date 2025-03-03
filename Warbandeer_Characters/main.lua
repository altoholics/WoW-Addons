local _, ns = ...
local API = ns.api

local tinsert = ns.lua.tinsert
local Player = ns.wow.Player
local UnitRace = ns.wow.UnitRace

function ns:onLogin()
  local name = Player:GetName()
  local _, raceFile, raceId = UnitRace("player")
  local raceIndex, isAlliance = ns.NormalizeRaceId(raceId)

  local data = self.db.characters
  if not data[name] then
    data[name] = ns.Data.newCharacter()
    self.db.numCharacters = self.db.numCharacters + 1
  end
  local c = data[name]
  self.currentPlayer = name
  self.currentData = c

  c.name = name
  c.classId = Player:GetClassId()
  c.className = Player:GetClassName()
  c.level = Player:GetLevel()
  c.race = raceFile
  c.raceId = raceId
  c.raceIdx = raceIndex
  c.isAlliance = isAlliance
  c.ilvl = Player:GetAverageItemLevel()
  c.realm = ns.wow.RealmName

  c.greatVault = Player:GetRewardOptions()

  local professions = Player:GetProfessions()
  c.prof1 = professions.prof1:GetInfo()
  c.prof2 = professions.prof2:GetInfo()
  c.fishing = professions.fishing:GetInfo()
  c.cooking = professions.cooking:GetInfo()
end

function ns:PLAYER_LEVEL_UP()
  self.currentData.level = Player:GetLevel()
end
ns:registerEvent("PLAYER_LEVEL_UP")

function ns:PLAYER_EQUIPMENT_CHANGED()
  self.currentData.ilvl = Player:GetAverageItemLevel()
end
ns:registerEvent("PLAYER_EQUIPMENT_CHANGED")

function ns:WEEKLY_REWARDS_UPDATE(...)
  self.currentData.greatVault = Player:GetRewardOptions()
end
ns:registerEvent("WEEKLY_REWARDS_UPDATE")

function ns:WEEKLY_REWARDS_ITEM_CHANGED(...)
  self.currentData.greatVault = Player:GetRewardOptions()
end
ns:registerEvent("WEEKLY_REWARDS_ITEM_CHANGED")

function API:GetCurrentCharacter() return ns.currentPlayer end

function API:GetCharacterData(char)
  -- todo: return a copy so it is immutable
  return ns.db.characters[char or ns.currentPlayer]
end

function API:GetNumCharacters() return ns.db.numCharacters end
function API:GetNumMaxLevel()
  local n = 0
  for _,c in pairs(ns.db.characters) do
    if c.level == ns.wow.maxLevel then n = n + 1 end
  end
  return n
end

function API:GetAllCharacters()
  local list = {}
  for _,c in pairs(ns.db.characters) do tinsert(list, c) end
  return list
end

function API:GetAllianceCharacters()
  local c = {}
  for _,t in pairs(ns.db.characters) do
    if t.isAlliance then table.insert(c, t) end
  end
  return c
end

function API:GetHordeCharacters()
  local c = {}
  for _,t in pairs(ns.db.characters) do
    if not t.isAlliance then table.insert(c, t) end
  end
  return c
end
