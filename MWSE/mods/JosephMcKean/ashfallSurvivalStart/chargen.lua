local Recipe = require("CraftingFramework").Recipe

local common = require("JosephMcKean.ashfallSurvivalStart.common")
local log = common.createLogger("chargen")

local chargen = {}

local isVanillaItem = { ["common_shirt_01"] = true, ["common_pants_01"] = true, ["common_shoes_01"] = true }

local function transferItems()
	for _, stack in pairs(tes3.player.object.inventory) do
		if not isVanillaItem[stack.object.id:lower()] then
			tes3.transferItem({
				from = tes3.player,
				to = "jsmk_ass_co_safe",
				item = stack.object,
				count = stack.count,
				playSound = false,
				limitCapacity = false,
				reevaluateEquipment = true,
			})
		end
	end
end

local function addSpell()
	log:debug("adding survival spell...")
	local spellId = "jsmk_ass_sp_survivalistssense"
	local spell = tes3.getObject(spellId) ---@cast spell tes3spell
	if not spell then
		log:debug("creating survival spell...")
		spell = tes3.createObject({ objectType = tes3.objectType.spell, id = spellId })
		spell.name = "Survivalist's Sense"
		spell.castType = tes3.spellType.spell
		log:debug("setting the effects...")
		-- spell.effects[1] = { id = tes3.effect.survivalistsSense, range = tes3.effectRange.self }
		spell.effects[1] = { id = tes3.effect.detectAnimal, range = tes3.effectRange.self }
		spell.magickaCost = 0
		log:debug("spell created")
	end
	tes3.addSpell({ reference = tes3.player, spell = "jsmk_ass_sp_survivalistssense" })
	log:debug("spell added")
end

local function transferCharGenItems(e)
	timer.start({
		type = timer.simulate,
		duration = 0.8, -- AotC is 0.7
		callback = transferItems,
	})
	timer.start({
		type = timer.simulate,
		duration = 2.1, -- ashfall is 2.0
		callback = function()
			tes3.messageBox("Modded starting equipment has been temporarily removed.")
			transferItems()
			-- addSpell()
			Recipe.getRecipe("jsmk_ass_ac_raft"):learn()
		end,
	})
end
event.register("charGenFinished", transferCharGenItems)

return chargen
