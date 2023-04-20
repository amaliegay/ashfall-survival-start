---@param e uiEventEventData
local function onUiEvent(e)
	if not tes3.player then
		return
	end
	if not tes3.player.cell.id:startswith("Masartus") then
		return
	end
	if tes3.player.data.ass and tes3.player.data.ass.hasMap then
		return
	end
	local menu = e.source:getTopLevelMenu()
	if menu.name ~= "MenuMap" then
		return
	end
	local worldMap = menu:findChild(tes3ui.registerID("MenuMap_world"))
	worldMap.visible = false
end
event.register("uiEvent", onUiEvent)
