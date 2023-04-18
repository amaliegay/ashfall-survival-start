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
		end,
	})
end
event.register("charGenFinished", transferCharGenItems)

return chargen
