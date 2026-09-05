/* Makes your Burden Twisted always convert healing into a certain damage type. Not always better, but certainly more consistent, so you can tailor your heal-mixes and all that.
*/
/datum/power/theologist/twisted_fixed_fate
	name = "Fixed Fate"
	desc = "Choose a damage type besides suffocation. All uses of A Burden Twisted convert the target's damage into the chosen type, disregarding regular restrictions."
	security_record_text = "Subject's healing powers always convert the target's wounds into a fixed type."
	value = 2
	required_powers = list(/datum/power/theologist_root/twisted)

/datum/power/theologist/twisted_fixed_fate/get_security_record_text()
	return "Subject's healing powers always convert the target's injuries into [get_preferred_damage_type()] injuries."

// Normally I try to make upgrades not be hardcoded into the powers, but this is such a small thing.
/datum/power/theologist/twisted_fixed_fate/post_add()
	. = ..()
	var/datum/action/cooldown/power/theologist/theologist_root/twisted/twisted_action = get_twisted_action()
	if(!twisted_action)
		return
	twisted_action.fixed_damage_type = get_preferred_damage_type()

/datum/power/theologist/twisted_fixed_fate/remove()
	var/datum/action/cooldown/power/theologist/theologist_root/twisted/twisted_action = get_twisted_action()
	if(twisted_action)
		twisted_action.fixed_damage_type = null
	return ..()

/// Gets the action belonging to the required A Burden Twisted power.
/datum/power/theologist/twisted_fixed_fate/proc/get_twisted_action()
	var/datum/power/theologist_root/twisted/twisted_power = power_holder?.get_power(/datum/power/theologist_root/twisted)
	var/datum/action/cooldown/power/theologist/theologist_root/twisted/twisted_action = twisted_power?.action_path
	if(istype(twisted_action))
		return twisted_action
	return null

/// Converts the player-facing preference into the damage type used internally by A Burden Twisted.
/datum/power/theologist/twisted_fixed_fate/proc/get_preferred_damage_type()
	var/damage_type_choice = power_holder?.client?.prefs?.read_preference(/datum/preference/choiced/twisted_fixed_fate_damage_type)
	switch(damage_type_choice)
		if("Burn")
			return "burn"
		if("Toxin")
			return "tox"
		else
			return "brute"

/// Preference choice for the damage type used by Fixed Fate.
/datum/preference/choiced/twisted_fixed_fate_damage_type
	category = PREFERENCE_CATEGORY_MANUALLY_RENDERED
	savefile_key = "twisted_fixed_fate_damage_type"
	savefile_identifier = PREFERENCE_CHARACTER

/datum/preference/choiced/twisted_fixed_fate_damage_type/create_default_value()
	return "Brute"

/datum/preference/choiced/twisted_fixed_fate_damage_type/init_possible_values()
	return list("Brute", "Burn", "Toxin")

/datum/preference/choiced/twisted_fixed_fate_damage_type/is_accessible(datum/preferences/preferences)
	if(!..(preferences))
		return FALSE
	return TRUE

/datum/preference/choiced/twisted_fixed_fate_damage_type/apply_to_human(mob/living/carbon/human/target, value)
	return

/datum/power_constant_data/twisted_fixed_fate
	associated_typepath = /datum/power/theologist/twisted_fixed_fate
	customization_options = list(/datum/preference/choiced/twisted_fixed_fate_damage_type)
