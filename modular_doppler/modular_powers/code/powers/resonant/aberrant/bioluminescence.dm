// he be glowin. can be toggled on or off.
/datum/power/aberrant/bioluminescence
	name = "Bioluminescence"
	desc = "You can glow! You passively emit the chosen light color; which can be toggled on or off at will. Very slightly increases passive hunger when enabling or disabling the light."
	value = 1
	security_record_text = "Subject has been observed to glow through bioluminescence."

	required_powers = list(/datum/power/aberrant_root/beastial, /datum/power/aberrant_root/monstrous)
	required_allow_any = TRUE
	action_path = /datum/action/cooldown/power/aberrant/bioluminescence

/datum/action/cooldown/power/aberrant/bioluminescence
	name = "Bioluminescence"
	desc = "Toggle on or off your natural light!"
	button_icon = 'icons/obj/lighting.dmi'
	button_icon_state = "lantern-blue-on"

	cooldown_time = 5
	// start with da pretty lights on
	active = TRUE

	var/obj/effect/dummy/lighting_obj/moblight/biolum_light
	/// Range of the light
	var/biolum_range = 3
	/// Strength of the light
	var/biolum_power = 1
	/// Color of the light
	var/biolum_color = "#66c5dd"
	/// Extra range of the light caused by being shaked
	var/biolum_bonus_range = 0
	/// Choiced option for the size of the light (from prefs)
	var/biolum_size_choice

/datum/action/cooldown/power/aberrant/bioluminescence/Grant(mob/granted_to)
	. = ..()
	RegisterSignal(granted_to, COMSIG_ATOM_DISPEL, PROC_REF(on_dispel))
	RegisterSignal(granted_to, COMSIG_CARBON_HELP_ACT, PROC_REF(on_help_act))
	init_biolum_settings_from_prefs()
	if(active)
		enable_bioluminescence()

/datum/action/cooldown/power/aberrant/bioluminescence/Remove(mob/removed_from)
	. = ..()
	UnregisterSignal(removed_from, list(COMSIG_ATOM_DISPEL, COMSIG_CARBON_HELP_ACT))
	disable_bioluminescence()

/datum/action/cooldown/power/aberrant/bioluminescence/use_action(mob/living/user, atom/target)
	active = !active
	if(active)
		enable_bioluminescence()
	else
		disable_bioluminescence()
	user.adjust_nutrition(-2)
	owner.balloon_alert(owner, active ? "bioluminescence on" : "bioluminescence off")
	build_all_button_icons(UPDATE_BUTTON_STATUS)
	return TRUE

/// Applies the appropriate size from the choiced component.
/datum/action/cooldown/power/aberrant/bioluminescence/proc/apply_biolum_size_settings()
	if(isnull(biolum_size_choice))
		biolum_size_choice = "Medium"
	var/size_range = GLOB.bioluminescence_sizes[biolum_size_choice]
	if(isnum(size_range))
		biolum_range = size_range
	else
		biolum_range = GLOB.bioluminescence_sizes["Medium"]

/// Gets the size and color and applies it to the mob.
/datum/action/cooldown/power/aberrant/bioluminescence/proc/init_biolum_settings_from_prefs()
	if(!owner)
		return
	var/color_choice = owner?.client?.prefs?.read_preference(/datum/preference/color/bioluminescence_color)
	var/size_choice = owner?.client?.prefs?.read_preference(/datum/preference/choiced/bioluminescence_size)
	if(isnull(color_choice))
		color_choice = "66c5dd"
	if(isnull(size_choice))
		size_choice = "Medium"
	biolum_size_choice = size_choice
	biolum_color = color_choice
	if(!isnull(biolum_color) && !findtext(biolum_color, "#", 1, 2))
		biolum_color = "#[biolum_color]"
	apply_biolum_size_settings()

/// We turn the light on.
/datum/action/cooldown/power/aberrant/bioluminescence/proc/enable_bioluminescence()
	if(!owner || !isliving(owner))
		return
	var/mob/living/glowstick_person = owner
	QDEL_NULL(biolum_light)
	biolum_light = glowstick_person.mob_light(
		range = biolum_range + biolum_bonus_range,
		power = biolum_power,
		color = biolum_color
	)

/// We turn the light off.
/datum/action/cooldown/power/aberrant/bioluminescence/proc/disable_bioluminescence()
	QDEL_NULL(biolum_light)

/// On dispel, turn the lights off.
/datum/action/cooldown/power/aberrant/bioluminescence/proc/on_dispel(mob/owner, atom/dispeller)
	SIGNAL_HANDLER
	if(!active)
		return DISPEL_RESULT_DISPELLED
	active = FALSE
	disable_bioluminescence()
	build_all_button_icons(UPDATE_BUTTON_STATUS)
	return DISPEL_RESULT_DISPELLED

/// You can shake em like glowsticks to make em glow MORE.
/datum/action/cooldown/power/aberrant/bioluminescence/proc/on_help_act(mob/living/carbon/source, mob/living/carbon/helper)
	SIGNAL_HANDLER
	if(!active || !owner || source != owner)
		return
	if(biolum_bonus_range >= 2)
		return
	biolum_bonus_range++
	enable_bioluminescence()
	addtimer(CALLBACK(src, PROC_REF(decay_biolum_bonus)), 60 SECONDS)

/// Undoes the bonus light from being shaked.
/datum/action/cooldown/power/aberrant/bioluminescence/proc/decay_biolum_bonus()
	if(biolum_bonus_range <= 0)
		return
	biolum_bonus_range--
	if(active)
		enable_bioluminescence()

// Preference choice for Bioluminescence color selection.
/datum/preference/color/bioluminescence_color
	category = PREFERENCE_CATEGORY_MANUALLY_RENDERED
	savefile_key = "bioluminescence_color"
	savefile_identifier = PREFERENCE_CHARACTER

/datum/preference/color/bioluminescence_color/create_default_value()
	return "66c5dd"

/datum/preference/color/bioluminescence_color/is_accessible(datum/preferences/preferences)
	if (!..(preferences))
		return FALSE

	return TRUE

/datum/preference/color/bioluminescence_color/apply_to_human(mob/living/carbon/human/target, value)
	return

// Preference choice for Bioluminescence size selection.
/datum/preference/choiced/bioluminescence_size
	category = PREFERENCE_CATEGORY_MANUALLY_RENDERED
	savefile_key = "bioluminescence_size"
	savefile_identifier = PREFERENCE_CHARACTER

/datum/preference/choiced/bioluminescence_size/create_default_value()
	return "Medium"

/datum/preference/choiced/bioluminescence_size/init_possible_values()
	var/list/values = list()
	for(var/choice in GLOB.bioluminescence_sizes)
		values += choice
	return values

/datum/preference/choiced/bioluminescence_size/is_accessible(datum/preferences/preferences)
	if (!..(preferences))
		return FALSE

	return TRUE

/datum/preference/choiced/bioluminescence_size/apply_to_human(mob/living/carbon/human/target, value)
	return

/datum/power_constant_data/bioluminescence
	associated_typepath = /datum/power/aberrant/bioluminescence
	customization_options = list(
		/datum/preference/color/bioluminescence_color,
		/datum/preference/choiced/bioluminescence_size
	)
