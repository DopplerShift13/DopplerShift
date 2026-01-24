/datum/action/innate/teshari_tablerun
	name = "Enable Tablerunning"
	desc = "Toggle your ability to effortlessly jump over and on top of tables."
	check_flags = NONE
	button_icon = 'modular_doppler/modular_species/species_types/teshari/icons/abilities/actions.dmi'
	button_icon_state = "teshari_tablerunning"

/datum/action/innate/teshari_tablerun/Activate()
	active = TRUE
	passtable_on(owner, SPECIES_TRAIT)
	owner.balloon_alert(owner, "now tablerunning")

/datum/action/innate/teshari_tablerun/Deactivate()
	active = FALSE
	passtable_off(owner, SPECIES_TRAIT)
	owner.balloon_alert(owner, "no longer tablerunning")

/datum/action/innate/teshari_tablerun/Remove(mob/removed_from)
	. = ..()
	passtable_off(removed_from, SPECIES_TRAIT)
