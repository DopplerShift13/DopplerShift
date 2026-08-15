
/*/datum/power/enigmatist_spell/lodestone_legends
	name = "Lodestone Legends"
	desc = "Activate with any type of Chalk in hand to be told your GPS \
	position. Causes minor damage to the Chalk"

	value = 1
	priority = POWER_PRIORITY_BASIC
	// Any chalk can use us, whatsoever.
	enigmatist_type = ENIGMATIST_ANY_ALL

/datum/power/enigmatist_spell/lodestone_legends/chalk_add_context(
	obj/item/enigmatist_chalk/held_chalk,
	list/context,
	obj/item/held_item,
	mob/user,
)
	if(held_chalk != held_item)
		return NONE
	context[SCREENTIP_CONTEXT_LMB] = "Get GPS position"
	return CONTEXTUAL_SCREENTIP_SET

/datum/power/enigmatist_spell/lodestone_legends/chalk_attack_self(obj/item/enigmatist_chalk/used_chalk, mob/user, modifiers)
	if(!damage_chalk(used_chalk, user, ENIGMATIST_CHALK_MINOR_DAMAGE))
		return
	var/turf/current_turf = get_turf(used_chalk)
	to_chat(user, span_notice("Your current coordinates are... [current_turf.x]x, [current_turf.y]y, [current_turf.z]z..."))*/
