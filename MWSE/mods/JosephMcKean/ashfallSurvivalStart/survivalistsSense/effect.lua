local magickaExpanded = include("OperatorJack.MagickaExpanded.magickaExpanded")

tes3.claimSpellEffectId("survivalistsSense", 950)

local function addMagicEffects()
	tes3.addMagicEffect({
		-- Base information.
		id = tes3.effect.survivalistsSense,
		name = "Survivalist's Sense",
		description = "Allows the caster of this effect to detect nearby branches, stone, and flint.",
        school = tes3.magicSchool.mysticism,

		-- Basic dials.
		baseCost = 1,

		-- Various flags.
		allowEnchanting = true,
		allowSpellmaking = true,
		appliesOnce = true,
		canCastTarget = false,
		canCastTouch = false,
		canCastSelf = true,
		hasNoDuration = true,
		hasNoMagnitude = true,

		-- Graphics/sounds.
		icon = "jsmk\\ass\\survivalistsSense.dds",

		-- Required callbacks.
		onTick = function(e)
			e:trigger()
		end,
	})
end
event.register("magicEffectsResolved", addMagicEffects)
