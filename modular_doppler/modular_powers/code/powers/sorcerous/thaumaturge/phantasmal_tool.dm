/*
	For the people that don't want to hunt for tools, or are just too bothered to carry one.
*/
/datum/power/thaumaturge/phantasmal_tool
	name = "Phantasmal Tool"
	desc = "Summons a basic tool of your choice in your hand, that disappears if dropped or after a duration. Requires Affinity 1 to cast. Affinity gives a chance to not consume charges on cast."
	value = 3

	archetype = POWER_ARCHETYPE_SORCEROUS
	path = POWER_PATH_THAUMATURGE
	action_path = /datum/action/cooldown/power/thaumaturge/phantasmal_tool
	required_powers = list(/datum/power/thaumaturge_root)
	required_allow_subtypes = TRUE

/datum/action/cooldown/power/thaumaturge/phantasmal_tool
	name = "Phantasmal Tool"
	desc = "Summons a basic tool of your choice in your hand, that disappears if dropped or after a duration. Has a chance not to consume charges."
	button_icon = 'icons/obj/antags/cult/structures.dmi'
	button_icon_state = "tomealtar"

	max_charges = 5
	required_affinity = 1

/datum/action/cooldown/power/thaumaturge/phantasmal_tool/use_action(mob/living/user, atom/target)
	to_chat(user, span_notice("hello WORLD [affinity]"))
	return TRUE
