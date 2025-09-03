
/datum/power/item_power/thaumaturge_root
	name = "Spell Preparation"
	desc = "Wizards, sorcerers, sages. These are all Thaumaturges, who channel the Resonant song \
	with their bodies and their words, whether they discover these through careful study or \
	strong intuition."

	value = 5
	mob_trait = TRAIT_ARCHETYPE_SORCEROUS
	archetype = POWER_ARCHETYPE_SORCEROUS
	path = POWER_PATH_THAUMATURGE
	priority = POWER_PRIORITY_ROOT

/datum/power/item_power/thaumaturge_root/add_unique(client/client_source)
	var/obj/item/book/random/spellbook = new(get_turf(power_holder))
	spellbook.name = "[power_holder.real_name]'s spellbook"
	give_item_to_holder(spellbook, list(LOCATION_BACKPACK, LOCATION_HANDS))

/datum/power/item_power/thaumaturge_root/add(client/client_source)
	var/datum/action/cooldown/spell/touch/prestidigitation/that_magic_touch = new
	that_magic_touch.Grant(power_holder)








