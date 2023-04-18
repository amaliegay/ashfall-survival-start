local Condition = require("mer.ashfall.conditions.Condition")

local common = require("JosephMcKean.ashfallSurvivalStart.common")
local log = common.createLogger("loneliness")

local loneliness = Condition:new{
	id = "loneliness",
	default = "fine",
	showMessageOption = "showLoneliness",
	enableOption = "enableLoneliness",
	min = 0,
	max = 100,
	minDebuffState = "lonely",
	states = {
		abandoned = { text = "Abandoned", min = 80, max = 100 },
		desolate = { text = "Desolate", min = 60, max = 80 },
		veryLonely = { text = "Very Lonely", min = 40, max = 60 },
		lonely = { text = "Lonely", min = 20, max = 40 },
		fine = { text = "Fine", min = 0, max = 20 },
	},
}

local lonelinessData = {
	blockID = tes3ui.registerID("AshfallSurvivalStart:lonelinessUIBlock"),
	fillBarID = tes3ui.registerID("AshfallSurvivalStart:lonelinessFillBar"),
	conditionID = tes3ui.registerID("AshfallSurvivalStart:lonelinessConditionId"),
	showUIFunction = function()
		return tes3.player.cell.id:startswith("Masartus")
	end,
	conditionTypes = loneliness.states,
	defaultCondition = "fine",
	need = "loneliness",
	color = { 155 / 255, 86 / 255, 174 / 255 },
	name = "Loneliness",
	getTooltip = function()
		return string.format(("You feel more and more lonely being alone on the island. " ..
		                     "Interact with friendly people or creature reduces the sturdiness of loneliness." .. "\n\nYour current loneliness level is %d%%. %s"),
		                     loneliness:getValue(), loneliness:getCurrentStateMessage())
	end,
}

local function setupNeedsElementBlock(element)
	--[[.autoHeight = true
	element.autoWidth = true

	element.paddingBottom = 1
	element.widthProportional = 1
	element.flowDirection = "left_to_right"]]
end

local function setupNeedsBar(element)
	--[[element.widget.showText = false
	element.height = 17
	element.widthProportional = 1.0]]
end

local function setupConditionLabel(element)
	--[[element.absolutePosAlignX = 0.5
	element.borderAllSides = -2
	element.absolutePosAlignY = 0.0
	element.widthProportional = 1.0]]
end

local function updateNeedsBlock(menu, data)
	local need = loneliness
	local block = menu:findChild(data.blockID)

	if not need:isActive() then
		block.visible = false
	else
		if block and block.visible == false then
			block.visible = true
		end
	end

	local fillBar = menu:findChild(data.fillBarID)
	local conditionLabel = menu:findChild(data.conditionID)
	if fillBar and conditionLabel then
		-- update condition
		conditionLabel.text = need:getCurrentStateData().text
		-- update fillBar
		local needsLevel
		needsLevel = math.floor(need:getValue())
		fillBar.widget.current = need.max - needsLevel
	end
end

local function createTooltip(header, label)
	--[[local tooltip = tes3ui.createTooltipMenu()

	local outerBlock = tooltip:createBlock()
	outerBlock.flowDirection = "top_to_bottom"
	outerBlock.paddingTop = 6
	outerBlock.paddingBottom = 12
	outerBlock.paddingLeft = 6
	outerBlock.paddingRight = 6
	outerBlock.maxWidth = 300
	outerBlock.autoWidth = true
	outerBlock.autoHeight = true

	local headerLabel = outerBlock:createLabel({ text = header })
	headerLabel.autoHeight = true
	headerLabel.width = 285
	headerLabel.color = tes3ui.getPalette("header_color")
	headerLabel.wrapText = true

	local descriptionLabel = outerBlock:createLabel({ text = label })
	descriptionLabel.autoHeight = true
	descriptionLabel.width = 285
	descriptionLabel.wrapText = true

	tooltip:updateLayout()]]
end

local function updateNeedsUI(menu)
	--[[local needsBlock = menu:findChild(tes3ui.registerID("Ashfall:needsBlock"))
	local needsActive = loneliness:isActive()
	needsBlock.visible = needsActive
	updateNeedsBlock(menu, lonelinessData)
	menu:updateLayout()]]
end

---@param e uiActivatedEventData
local function createLonelinessUI(e)
	log:debug("Finding needs block")
	local needsBlock = e.element:findChild(tes3ui.registerID("Ashfall:needsBlock"))
	if not needsBlock then
		return
	end
	log:debug("Found needs block")
	local data = lonelinessData
	local need = loneliness

	local block = needsBlock:createBlock({ id = data.blockID })
	setupNeedsElementBlock(block)

	log:debug("Creating fillbar with id %s", data.fillBarID)
	local fillBar = block:createFillBar({ id = data.fillBarID, current = need.max, max = need.max })
	setupNeedsBar(fillBar)

	fillBar.widget.fillColor = data.color

	log:debug("Creating label with id %s", data.conditionID)
	local conditionLabel = block:createLabel({ id = data.conditionID, text = need.states[need.default].text })
	setupConditionLabel(conditionLabel)

	fillBar:register("help", function()
		createTooltip(data.name, data.getTooltip())
	end)
	conditionLabel:register("help", function()
		createTooltip(data.name, data.getTooltip())
	end)
	updateNeedsUI(e.element)
end
event.register("uiActivated", createLonelinessUI, { filter = "MenuInventory", priority = -10 })