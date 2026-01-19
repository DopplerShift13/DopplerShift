
/**
 * This place is a message... and part of a system of messages... pay attention to it!
 * Sending this message was important to us. We considered ourselves to be a powerful culture.
 * This place is not a place of honor... no highly esteemed deed is commemorated here... nothing valued is here.
 * What is here was dangerous and repulsive to us. This message is a warning about danger.
 * The danger is in a particular location... it increases towards a center... the center of danger is here... of a particular size and shape, and below us.
 * The danger is still present, in your time, as it was in ours.
 * The danger is to the body, and it can kill.
 * The form of the danger is an emanation of energy.
 * The danger is unleashed only if you substantially disturb this place physically. This place is best shunned and left uninhabited.
 */

/datum/preference_middleware/powers
	action_delegations = list(
		"give_power" = PROC_REF(give_power),
		"remove_power" = PROC_REF(remove_power),
	)

/datum/preference_middleware/powers/ui_act(action, list/params, datum/tgui/ui, datum/preferences/prefs)
	// Notice that power preferences were nuked; queqed to occur when the user opens the character setup UI
	. = ..()
	if(.)
		return

	// The message, resets after being send so you don't see it more than once.
	if(prefs.power_sanitize_notice)
		var/mob/user = ui.user
		if(user)
			to_chat(user, span_boldwarning(prefs.power_sanitize_notice))
		prefs.power_sanitize_notice = null

	return FALSE

/datum/preference_middleware/powers/get_ui_data(mob/user)
	// Show "kerplode" notice once when the UI is opened (avoids init spam)
	// TODO: Move this when we overhaul this mess.
	if(preferences.power_sanitize_notice)
		to_chat(user, span_boldwarning("[preferences.power_sanitize_notice]"))
		preferences.power_sanitize_notice = null

	var/list/data = list()

	var/list/thaumaturge = list()
	var/list/enigmatist = list()
	var/list/theologist = list()

	var/list/psyker = list()
	var/list/cultivator = list()
	var/list/aberrant = list()

	var/list/warfighter = list()
	var/list/expert = list()
	var/list/augmented = list()

	var/current_points = 0
	for(var/power_name in preferences.all_powers)
		var/datum/power/power_type = SSpowers.powers[power_name]
		current_points += power_type.value

	for(var/power_name in SSpowers.powers)
		var/datum/power/power_type = SSpowers.powers[power_name]

		var/has_given_power = (power_name in preferences.all_powers)

		// TODO: GRAY OUT powers you:
		// Don't have the requirements for.
		// Have powers building upon.
		// Have an incompatible power for.
		// ^ must touch tgui to set a new state/colour for this shit

		var/locked_in = FALSE
		if(has_given_power)
			if(get_requiring_power(power_type))
				locked_in = TRUE
		else
			if(get_incompatible_power(power_type) || get_required_power(power_type))
				locked_in = TRUE

		var/state
		var/word
		var/color
		var/powertype
		var/rootpower = null

		if(power_type.priority == POWER_PRIORITY_ROOT)
			powertype = "crown"
		else
			powertype = ""
			rootpower = power_type.archetype

		if(has_given_power)
			word = "Forget"
			state = "bad"
			if(locked_in)
				color = "0.5"
		else
			if(locked_in || ((power_type.value + current_points) > MAXIMUM_POWER_POINTS))
				state = "transparent"
				word = "N/A"
				color = "0.5"
			else
				state = "good"
				word = "Learn"
				color = "1"

		var/final_list = list(list(
				"description" = power_type.desc,
				"name" = power_type.name,
				"cost" = power_type.value,
				"state" = state,
				"word" = word,
				"color" = color,
				"powertype" = powertype,
				"rootpower" = rootpower,
			))

		switch(power_type.path)
			if(POWER_PATH_THAUMATURGE)
				thaumaturge += final_list
			if(POWER_PATH_ENIGMATIST)
				enigmatist += final_list
			if(POWER_PATH_THEOLOGIST)
				theologist += final_list
			if(POWER_PATH_PSYKER)
				psyker += final_list
			if(POWER_PATH_CULTIVATOR)
				cultivator += final_list
			if(POWER_PATH_ABERRANT)
				aberrant += final_list
			if(POWER_PATH_WARFIGHTER)
				warfighter += final_list
			if(POWER_PATH_EXPERT)
				expert += final_list
			if(POWER_PATH_AUGMENTED)
				augmented += final_list


	data["total_power_points"] = MAXIMUM_POWER_POINTS
	data["thaumaturge"] = thaumaturge
	data["enigmatist"] = enigmatist
	data["theologist"] = theologist
	data["psyker"] = psyker
	data["cultivator"] = cultivator
	data["aberrant"] = aberrant
	data["warfighter"] = warfighter
	data["expert"] = expert
	data["augmented"] = augmented
	data["power_points"] = current_points

	return data

/**
 * Gives a power to a character using the params list provided by tgui.
 * Runs through multiple checks to ensure that the power can be learned.
 */
/datum/preference_middleware/powers/proc/give_power(list/params, mob/user)
	var/power_name = params["power_name"]
	var/datum/power/power_type = SSpowers.powers[power_name]
	if(isnull(preferences.all_powers))
		preferences.all_powers = list()

	if(isnull(power_type))
		return FALSE // Not a power.

	if(power_name in preferences.all_powers)
		return FALSE // Already have this power.

	// Make sure we stay in the same archetype.
	if(length(preferences.all_powers))
		var/datum/power/first_power_type = SSpowers.powers[preferences.all_powers[1]]
		if(power_type.archetype != first_power_type.archetype)
			to_chat(user, span_boldwarning("Mismatched archetype!"))
			return FALSE

	// Make sure we have the required powers.
	var/datum/power/required_power_type = get_required_power(power_type)
	if(required_power_type)
		to_chat(user, span_boldwarning("[power_name] is missing [required_power_type.name]!"))
		return FALSE

	// Make sure we don't select an incompatible power.
	var/datum/power/incompatible_power_type = get_incompatible_power(power_type)
	message_admins("giver_power BLACKLIST -<br>incompatible_power_type: [incompatible_power_type]")
	if(incompatible_power_type)
		to_chat(user, span_boldwarning("[power_name] is incompatible with [incompatible_power_type.name]!"))
		return FALSE

	// Make sure we don't go over our point cap.
	var/point_balance = power_type.value
	for(var/existing_power_name in preferences.all_powers)
		var/datum/power/existing_power_type = SSpowers.powers[existing_power_name]
		point_balance += existing_power_type.value
	if(point_balance > MAXIMUM_POWER_POINTS)
		to_chat(user, span_boldwarning("[power_name] costs too much!"))
		return FALSE

	preferences.all_powers += power_name
	return TRUE

/**
 * Remove Power
 *
 * Removes a power from a character using the params list provided by tgui.
 */
/datum/preference_middleware/powers/proc/remove_power(list/params, mob/user)
	var/power_name = params["power_name"]
	var/datum/power/power_type = SSpowers.powers[power_name]
	if(isnull(preferences.all_powers))
		preferences.all_powers = list()
		return FALSE // We don't have any powers.

	if(isnull(power_type))
		return FALSE // Not a power.

	if(!(power_name in preferences.all_powers))
		return FALSE // We don't have this power.

	// Make sure none of our other powers need this power.

	var/datum/power/requiring_power_type = get_requiring_power(power_type)
	if(requiring_power_type)
		to_chat(user, span_boldwarning("[power_name] is needed by [requiring_power_type.name]!"))
		return FALSE

	preferences.all_powers -= power_name
	return TRUE

/**
 * Checks whether we are missing at least one required power for a given power type,
 * and returns the first one encountered if so.
 */
/datum/preference_middleware/powers/proc/get_required_power(datum/power/power_type)
	var/list/required_powers = GLOB.powers_requirements_list[power_type]
	if(!length(required_powers))
		return
	for(var/datum/power/required_power_type as anything in required_powers)
		var/required_power_name = required_power_type.name
		if(!(required_power_name in preferences.all_powers))
			return required_power_type

/**
 * Checks whether at least one of our powers requires the given power type,
 * and returns the first one encountered if so.
 */
/datum/preference_middleware/powers/proc/get_requiring_power(datum/power/power_type)
	var/list/powers_requiring_this = GLOB.powers_inverse_requirements_list[power_type]
	if(!length(powers_requiring_this))
		return
	for(var/datum/power/requiring_power_type as anything in powers_requiring_this)
		if(requiring_power_type.name in preferences.all_powers)
			return requiring_power_type

/**
 * Checks whether a given power type is incompatible with our selected powers,
 * and returns the first one encountered if so.
 */
/datum/preference_middleware/powers/proc/get_incompatible_power(datum/power/power_type)
	for(var/list/blacklist as anything in GLOB.powers_blacklist)
		if(!(power_type in blacklist))
			continue
		for(var/datum/power/other_power_type as anything in blacklist)
			if(other_power_type.name in preferences.all_powers)
				return other_power_type

/datum/asset/simple/powers
	assets = list(
		"gear.png" = 'modular_doppler/modular_powers/icons/ui/powers/gear.png',
		"heart.png" = 'modular_doppler/modular_powers/icons/ui/powers/heart.png',
		"seal.png" = 'modular_doppler/modular_powers/icons/ui/powers/seal.png'
	)

/datum/preference_middleware/powers/get_ui_assets()
	return list(
		get_asset_datum(/datum/asset/simple/powers),
	)
