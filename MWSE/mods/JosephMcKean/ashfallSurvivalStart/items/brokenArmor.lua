---@param e deathEventData
local function breakArmor(e)
    if e.reference.id ~= "jsmk_ass_corpse" then return end
    for _, slot in pairs({
        tes3.armorSlot.leftPauldron, tes3.armorSlot.rightPauldron
    }) do
        local armor = tes3.getEquippedItem {
            actor = e.reference,
            objectType = tes3.objectType.armor,
            slot = slot
        }
        if armor then
            armor.itemData.condition = 1
        end
    end
end
event.register("death", breakArmor)
