local ashfall = require("mer.ashfall.interop")
local Recipe = require("CraftingFramework").Recipe

local common = require("JosephMcKean.ashfallSurvivalStart.common")
local log = common.createLogger("raft")

local id = "jsmk_ass_ac_raft"

local function transferItems()
	local safeRef = tes3.getReference("jsmk_ass_co_safe")
	for _, stack in pairs(safeRef.object.inventory) do
		tes3.transferItem({
			from = safeRef,
			to = tes3.player,
			item = stack.object,
			count = stack.count,
			playSound = false,
			limitCapacity = false,
			reevaluateEquipment = true,
		})
	end
	tes3.messageBox("Modded starting equipment has been added to your inventory.")
end

local function onWater(e)
	local cell = tes3.player.cell
	local waterLevel = cell.hasWater and cell.waterLevel
	if not cell.isInterior and waterLevel and e.reference.position.z - waterLevel < 10 then
		return true
	end
	return false
end

local function canSail(e)
	return tes3.player.data.ass.hasMap and onWater(e)
end

local sailHome = {
	text = "Sail Home",
	callback = function(e)
		if tes3.isModActive("TR_Mainland.esm") then
			tes3.positionCell({ reference = tes3.player, cell = "Bal Oyra", position = { 152976, 202552, 94 }, orientation = { 0, 0, 4.37 } })
		else
			tes3.positionCell({ reference = tes3.player, cell = "Dagon Fel", position = { 61617, 183466, 36 } })
		end
		transferItems()
		Recipe.getRecipe(id):unlearn()
	end,
	enableRequirements = canSail,
	tooltipDisabled = function(e)
		return {
			text = onWater(e) and "You don't know which direction is Vvardenfell. Maybe there's a map on this island." or "The raft needs to be placed on open water.",
		}
	end,
}

--- @param e CraftingFramework.MenuActivator.RegisteredEvent
local function registerBushcraftingRecipe(e)
	log:debug("Ashfall:ActivateBushcrafting:Registered")
	local bushcraftingActivator = e.menuActivator
	--- @type CraftingFramework.Recipe.data
	local recipe = {
		id = id,
		craftableId = id,
		additionalMenuOptions = { sailHome },
		description = "A raft to sail home.",
		materials = { { material = "wood", count = 14 }, { material = "resin", count = 4 }, { material = "rope", count = 7 }, { material = "straw", count = 1 } },
		skillRequirements = { ashfall.bushcrafting.survivalTiers.apprentice },
		soundType = "wood",
		category = "Structures",
	}
	local recipes = { recipe }
	bushcraftingActivator:registerRecipes(recipes)
end
event.register("Ashfall:ActivateBushcrafting:Registered", registerBushcraftingRecipe)
