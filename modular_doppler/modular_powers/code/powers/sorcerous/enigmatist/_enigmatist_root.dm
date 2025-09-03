
/datum/power/enigmatist_root
	name = "Produce Resonant Chalk"
	desc = "Learn how to produce Resonant Chalk with any crayon \
	and a sheet of plasma or Resonant Chalk Remnants. \
	This is mutually exclusive with Spell Preparation."

	value = 2
	mob_trait = TRAIT_ARCHETYPE_SORCEROUS
	archetype = POWER_ARCHETYPE_SORCEROUS
	path = POWER_PATH_ENIGMATIST
	priority = POWER_PRIORITY_ROOT

/datum/power/enigmatist_root/add(client/client_source)
	var/datum/action/cooldown/spell/touch/prestidigitation/that_magic_touch = new
	that_magic_touch.Grant(power_holder)

	power_holder.mind?.teach_crafting_recipe(/datum/crafting_recipe/resonant_chalk)
