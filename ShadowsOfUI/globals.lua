local _, ns = ...

-- This file serves as the global api layer for the addon
-- it is the only file with references to global vars.
-- This helps prevent accidental leakage, and performance issues
-- It also helps isolate the addon code from changes to global functions

ns.ui = LibNUI

function ns.CreateColor(r, g, b, a)
  return ns.wow.CreateColor(r/255, g/255, b/255, a)
end

function ns.GetPlayerLevelXP()
  local level = UnitLevel("player")
  local currentXP = UnitXP("player")
  local maxXP = UnitXPMax("player")
  return currentXP, maxXP, level, ns.wow.maxLevel
end

function ns.min(a, b)
  return a < b and a or b
end

-- Disable the reagent bag tutorial
-- /run HelpTip:HideAllSystem("TutorialReagentBag")
C_CVar.SetCVarBitfield("closedInfoFrames", LE_FRAME_TUTORIAL_EQUIP_REAGENT_BAG, true)
C_CVar.SetCVar("professionToolSlotsExampleShown", 1)
C_CVar.SetCVar("professionAccessorySlotsExampleShown", 1)
