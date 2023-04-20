event.register("initialized", function()
	event.register("loaded", function()
		tes3.player.data.ass = tes3.player.data.ass or {}
	end)
	-- require("JosephMcKean.ashfallSurvivalStart.survivalistsSense")
	require("JosephMcKean.ashfallSurvivalStart.chargen")
	require("JosephMcKean.ashfallSurvivalStart.items")
	require("JosephMcKean.ashfallSurvivalStart.weather")
end, { priority = 10 })

event.register("UIEXP:sandboxConsole", function(e)
	e.sandbox.detectBranches = function()
		local marker = tes3.createObject({ id = "marker_error", objectType = tes3.objectType.miscItem })
		marker.mesh = "merker_error.nif"
		for ref in tes3.player.cell:iterateReferences() do
			if not ref.disabled then
				if ref.id:startswith("ashfall_branch") or ref.id == "ashfall_stone" or ref.id == "ashfall_flint" then
					tes3.createReference({ object = "marker_error", position = ref.position, orientation = ref.orientation })
				end
			end
		end
	end
end)
