local framework = include("OperatorJack.MagickaExpanded.magickaExpanded")

if not framework then
	return
end

require("JosephMcKean.ashfallSurvivalStart.survivalistsSense.effect")

local magnitude = 10

local ReferenceController

-- Register event handlers
---@param e objectInvalidatedEventData
local function onObjectInvalidated(e)
	local ref = e.object
	if not ReferenceController then
		return
	end
	if ReferenceController.references[ref] then
		ReferenceController.references[ref] = nil
	end
end

event.register("objectInvalidated", onObjectInvalidated)

local function isBranch(ref)
	local id = ref.object.id
	if id:startswith("ashfall_branch") or id == "ashfall_stone" or id == "ashfall_flint" then
		return true
	end
	return false
end

---@param ref tes3reference
local function attach(ref)
	if ref.sceneNode then
		local vfxPath = "jsmk\\ass\\survivalistsSense.nif"
		local vfx = tes3.loadMesh(vfxPath)
		local node = vfx:clone() ---@cast node niNode
		ref.sceneNode:attachChild(node, true)
		ref.sceneNode:update()
		ref.sceneNode:updateEffects()
	end
end

local function handler(ref)
	attach(ref)
	ReferenceController.references[ref] = true
end

local function callback()
	local cells = tes3.getActiveCells()
	local playerPosition = tes3.player.position
	local distances = {}
	for _, cell in pairs(cells) do
		for ref in cell:iterateReferences() do
			if (ref.disabled == false and ref.sceneNode) then
				if isBranch(ref) then
					local contains = ReferenceController.references[ref] or false
					if not contains then
						table.bininsert(distances, ref.position:distance(playerPosition), function(a, b)
							return a < b
						end)
						if table.size(distances) >= magnitude then
							table.remove(distances, #distances)
						end
					end
				end
			end
		end
	end
	for _, cell in pairs(cells) do
		for ref in cell:iterateReferences() do
			if (ref.disabled == false and ref.sceneNode) then
				if isBranch(ref) then
					local contains = ReferenceController.references[ref] or false
					if not contains then
						if ref.position:distance(playerPosition) <= distances[#distances] then
							handler(ref)
						end
					end
				end
			end
		end
	end
end

local function onSpellResist(e)
	for _, effect in pairs(e.sourceInstance.source.effects) do
		if effect.id == tes3.effect.survivalistsSense then
			timer.start({ iterations = -1, duration = 0.5, callback = callback })
		end
	end
end
event.register("spellResist", onSpellResist)

event.register("loaded", function()
	ReferenceController = { references = {} }
end)
