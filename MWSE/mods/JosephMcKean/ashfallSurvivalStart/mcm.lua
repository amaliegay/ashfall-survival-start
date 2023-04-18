local chargen = require("JosephMcKean.ashfallSurvivalStart.chargen")

local modName = "Ashfall Survival Start"

local modConfig = {}
function modConfig.onCreate(parent)
	local container = parent:createThinBorder{}
	container.flowDirection = "top_to_bottom"
	container.layoutHeightFraction = 1.0
	container.layoutWidthFraction = 1.0
	container.paddingAllSides = 12

	local header = container:createLabel{ text = modName }
	header.color = tes3ui.getPalette("header_color")
	header.borderAllSides = 12

	local button = container:createButton{ text = "New Game" }
    button.borderAllSides = 12
	button.paddingAllSides = 12
	button.paddingBottom = nil

	button:register("mouseClick", function(e)

		-- Click MCM OK button.
		local ok = parent:getTopLevelMenu():findChild("MWSE:ModConfigMenu_Close")
		if ok then
			ok:triggerEvent("mouseClick")
		end
		-- Hide MenuOptions if in-game.
		local menuOptions = tes3ui.findMenu("MenuOptions")
		if menuOptions and not tes3.onMainMenu() then
			menuOptions.visible = false
		end
		-- Shipwreck Chargen
		chargen.enabled = true
		tes3.newGame()
	end)
end

event.register("modConfigReady", function()
	mwse.registerModConfig(modName, modConfig)
end)
