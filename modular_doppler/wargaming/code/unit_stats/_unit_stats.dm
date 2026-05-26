/datum/wargame_unit_stats
	abstract_type = /datum/wargame_unit_stats
	/// The class of unit, "missile destroyer" or "asteroid" as examples
	var/unit_class
	/// Does this unit generate a random name for itself? Use only on ships
	var/generates_name = FALSE
	/// This unit's name, automatically generated or set manually. Can be null for no special name
	var/unit_name
	/// This unit's description
	var/unit_description
	/// How many conditions this unit can sustain before it is destroyed
	var/conditions_limit = 3
	/// A list of conditions currently applied on this unit
	var/list/current_conditions = list()
	/// List of all possible conditions that can be applied to this unit
	var/list/possible_conditions = list()
	/// This unit's armor class, or the amount an attack needs to roll above in order to cause a condition
	var/armor_class = 10
	/// This unit's evasion, added to the armor class for applicable attacks such as gunfire
	var/evasion_modifier = 0
	/// This unit's movement cost, how many action points to move one tile
	var/movement_cost = 1
	/// This unit's maximum action points per turn
	var/maximum_action_points = 3
	/// This unit's current action points
	var/action_points = 0
	/// If this unit counts as a "small vessel" for the purpose of attacks
	var/is_small_vessel = FALSE
	/// If this unit can be targetted by others at all, use for background stuff like space dust
	var/can_be_a_target = TRUE
	/// How big this unit is compared to others, used for cover calculations
	var/unit_size = WARGAME_SIZE_SMALL
	/// If this unit is talkative and will speak voicelines during specific actions
	var/talkative = TRUE
	/// How does this unit refer to the players in charge of it? Set by the team datum
	var/commander = "fleet"
	/// Associative list of weapon to radial choice, should be a list of weapons on init
	var/list/weaponry = list()

/datum/wargame_unit_stats/New()
	set_up_weaponry()

/// Sets the name of the attached hologram
/datum/wargame_unit_stats/proc/set_hologram_name(obj/structure/wargame_hologram/hologram)
	var/datum/wargaming_team/team = hologram.team_reference?.resolve()
	if(!isnull(team))
		commander = team.team_commander_reference
	if(!isnull(unit_description))
		hologram.desc = unit_description
	if(isnull(unit_class) && isnull(unit_name))
		return
	if(generates_name)
		unit_name = create_unit_name(team)
	if(isnull(unit_name))
		hologram.name = unit_class
	else
		hologram.name = "[unit_class] - ([unit_name])"

/// Generates a name for the unit, overwriten by subtypes for different naming schemes
/datum/wargame_unit_stats/proc/create_unit_name(datum/wargaming_team/team)
	if(isnull(team))
		return pick_list_replacements("~doppler/salvage_shuttle.json", "ship_name")
	else
		return "[team.team_ship_prefix] [pick_list_replacements("~doppler/salvage_shuttle.json", "ship_name_no_designation")]"

/// Sets up weapon datums and radial options
/datum/wargame_unit_stats/proc/set_up_weaponry()
	if(!length(weaponry))
		return // We just don't have weapons
	var/list/temporary_weapons = list()
	for(var/datum/wargame_weapon/weapon as anything in weaponry)
		weapon = new weapon()
		var/datum/radial_menu_choice/choice = new()
		choice.name = weapon.weapon_name
		choice.image = image(icon = WARGAME_ACTIONS_FILE, icon_state = weapon.radial_icon_state)
		choice.info = weapon.weapon_description()
		temporary_weapons[weapon] = choice
	weaponry = temporary_weapons

/// Sets our action points back to max
/datum/wargame_unit_stats/proc/make_ready()
	action_points = maximum_action_points

/// Runs through everything we might need to process during the effects phase
/datum/wargame_unit_stats/proc/effects_phase_process(obj/structure/wargame_hologram/hologram)
	var/repaired_this_phase = FALSE
	for(var/datum/wargame_condition/condition as anything in current_conditions)
		condition.condition_lifetime_left--
		if(condition.condition_lifetime_left <= 0)
			condition.removed_from_unit(src)
			current_conditions -= condition
			repaired_this_phase = TRUE
			qdel(condition)
	if(length(current_conditions) > conditions_limit)
		im_boutta_blow(hologram)
		return
	if(repaired_this_phase)
		var/list/lines = list(
			"Conditions repaired [commander], combat functionality restored.",
			"Repairs complete [commander], let's get back in the fight!",
			"[capitalize(commander)]? Damage control reports successful repairs.",
			"One less hole in the wall [commander], let's keep at it!",
			"Integrity partially restored [commander], let's show them we're still in this!",
		)
		hologram.say(pick(lines))
		playsound(hologram, 'sound/items/radio/radio_receive.ogg', 50, TRUE)

/// What to do when this unit explodes, good place to spawn a replacement "wreck" unit type
/datum/wargame_unit_stats/proc/im_boutta_blow(obj/structure/wargame_hologram/hologram)
	if(talkative)
		var/list/lines = list(
			"Reactor critical, all crew punch out!",
			"We're losing her!",
			"It's not- It's not shutting down!",
			"Damage critical, all crew to lifeboats.",
			"Red alert! Abandon ship!",
			"Send for rescue [commander]! We're-",
			"Punch out! Punch out! We're had!",
		)
		hologram.say(pick(lines))
		playsound(hologram, 'sound/items/radio/radio_receive.ogg', 50, TRUE)
	playsound(hologram, 'modular_doppler/wargaming/sound/ship_explode.ogg', 50, TRUE)
	do_sparks(3, FALSE, hologram)
	qdel(hologram)

/// Shows the menu for basic actions before moving into details
/datum/wargame_unit_stats/proc/basic_actions(mob/living/user, obj/hologram)
	var/list/basic_actions_radial = get_unit_basic_actions()
	var/radial_choice = show_radial_menu(user, hologram, basic_actions_radial)
	if(isnull(radial_choice))
		return
	perform_basic_actions(radial_choice, user, hologram)

/// Returns a list of basic actions this unit can perform
/datum/wargame_unit_stats/proc/get_unit_basic_actions()
	var/static/our_actions = list(
		WARGAME_UNIT_MOVE = image(icon = WARGAME_ACTIONS_FILE, icon_state = "unit_move"),
		WARGAME_UNIT_ATTACK = image(icon = WARGAME_ACTIONS_FILE, icon_state = "unit_attack"),
		// WARGAME_UNIT_SPECIAL = image(icon = WARGAME_ACTIONS_FILE, icon_state = "unit_special"), // To come later
	)
	return our_actions

/// Breaks out into our different procs for actions based on what was chosen
/datum/wargame_unit_stats/proc/perform_basic_actions(radial_choice, mob/living/user, obj/hologram)
	if(isnull(radial_choice))
		return
	switch(radial_choice)
		if(WARGAME_UNIT_MOVE)
			unit_movement(user, hologram)
		if(WARGAME_UNIT_ATTACK)
			unit_attacks(user, hologram)

/// Brings up a list of weapons to try and attack targets with
/datum/wargame_unit_stats/proc/unit_attacks(mob/living/user, obj/hologram)
	var/datum/wargame_weapon/weapon_choice = show_radial_menu(user, hologram, weaponry)
	if(isnull(weapon_choice))
		return
	var/obj/structure/wargame_hologram/target_hologram = weapon_choice.pick_target(user, hologram)
	if(isnull(target_hologram))
		return
	if(!weapon_choice.prefire_checks(user, src, hologram, target_hologram))
		return
	if(weapon_choice.firing_voiceline(src) && talkative)
		hologram.say(weapon_choice.firing_voiceline(src))
		playsound(hologram, 'sound/items/radio/radio_receive.ogg', 50, TRUE)
	weapon_choice.weapon_firing_message(hologram, target_hologram)
	weapon_choice.weapon_firing_sound(hologram)
	if(!weapon_choice.all_special_effects)
		var/impact = target_hologram.unit_stats.get_attacked(user, hologram, target_hologram, weapon_choice)
		weapon_choice.special_effects_fire(user, src, hologram, target_hologram, impact)
	else
		weapon_choice.special_effects_fire(user, src, hologram, target_hologram)
	if(!isnull(weapon_choice.maximum_ammo))
		if(weapon_choice.maximum_ammo <= 0)
			weaponry -= weapon_choice
			report_no_ammo(hologram, weapon_choice)
			qdel(weapon_choice)

/// Speaks a voiceline about a weapon being out of ammo
/datum/wargame_unit_stats/proc/report_no_ammo(obj/structure/wargame_hologram/hologram, datum/wargame_weapon/weapon)
	var/list/voicelines = list(
		"[weapon], ammo depleted.",
		"We're out of [weapon] [commander]!",
		"[capitalize(commander)]? [weapon], reporting ammunition zero.",
		"Bingo ammo on [weapon], [commander].",
		"That was the last of [weapon] we had!",
	)
	hologram.say(pick(voicelines))
	playsound(hologram, 'sound/items/radio/radio_receive.ogg', 50, TRUE)

/// Calculates getting attacked, returns TRUE if the weapon actually made impact with the enemy, even if it did nothing
/datum/wargame_unit_stats/proc/get_attacked(mob/living/user, obj/structure/wargame_hologram/attacking_hologram, obj/structure/wargame_hologram/hologram, datum/wargame_weapon/weapon_used)
	if(isnull(weapon_used))
		return FALSE
	var/incoming_attack_roll = roll(weapon_used.attack_roll)
	if(is_small_vessel && weapon_used.small_ship_disadvantage)
		incoming_attack_roll = min(incoming_attack_roll, roll(weapon_used.attack_roll))
	var/total_armor_class = weapon_used.evadable ? (calculate_armor_class(hologram) + calculate_evasion_mod(hologram)) : calculate_armor_class(hologram)
	if(incoming_attack_roll <= total_armor_class)
		if(attacking_hologram.unit_stats.talkative)
			attacking_hologram.say(missed_voiceline())
			playsound(attacking_hologram, 'sound/items/radio/radio_receive.ogg', 50, TRUE)
		hologram.visible_message(span_warning("Attacker's roll, [weapon_used.attack_roll], resulted in [incoming_attack_roll], which was less than or equal to the target's effective armor class, [total_armor_class]."), \
			blind_message = span_warning("Attacker's roll, [weapon_used.attack_roll], resulted in [incoming_attack_roll], which was less than or equal to the target's effective armor class, [total_armor_class]."))
		return FALSE
	if((incoming_attack_roll + weapon_used.damage_roll_bonus) <= armor_class)
		if(attacking_hologram.unit_stats.talkative)
			attacking_hologram.say(nonpen_voiceline())
			playsound(attacking_hologram, 'sound/items/radio/radio_receive.ogg', 50, TRUE)
		hologram.visible_message(span_warning("Attacker's damage roll, [incoming_attack_roll + weapon_used.damage_roll_bonus], was less than or equal to the target's armor class, [armor_class]."), \
			blind_message = span_warning("Attacker's damage roll, [incoming_attack_roll + weapon_used.damage_roll_bonus], was less than or equal to the target's armor class, [armor_class]."))
		playsound(hologram, 'modular_doppler/wargaming/sound/ship_hit.ogg', 50, TRUE)
		return TRUE // If our weapon is weak (PDC) then it makes our attack roll less than armor class
	var/datum/wargame_condition/new_condition = pick(possible_conditions)
	new_condition = new new_condition()
	new_condition.applied_to_unit(src, hologram)
	current_conditions += new_condition
	if(attacking_hologram.unit_stats.talkative)
		attacking_hologram.say(good_hit_voiceline())
		playsound(attacking_hologram, 'sound/items/radio/radio_receive.ogg', 50, TRUE)
	hologram.visible_message(span_warning("Attacker's roll, [weapon_used.attack_roll], resulted in [incoming_attack_roll], which was higher than the target's effective armor class, [total_armor_class]."), \
		blind_message = span_warning("Attacker's roll, [weapon_used.attack_roll], resulted in [incoming_attack_roll], which was higher than the target's effective armor class, [total_armor_class]."))
	hologram.Shake(2, 0, 2 SECONDS)
	playsound(hologram, 'modular_doppler/wargaming/sound/ship_hit.ogg', 50, TRUE)
	return TRUE

/// Returns a voiceline for missing the target
/datum/wargame_unit_stats/proc/missed_voiceline()
	var/list/lines = list(
		"Bad target track, we missed the target [commander]!",
		"[capitalize(commander)], we have missed the target.",
		"Looks like we missed!",
	)
	return pick(lines)

/// Returns a voiceline for hitting the target and doing nothing
/datum/wargame_unit_stats/proc/nonpen_voiceline()
	var/list/lines = list(
		"Hit- We didn't even scratch them!",
		"No effect on the target, bad hit [commander]!",
		"All we did was scratch the paint!",
	)
	return pick(lines)

/// Returns a voiceline for hitting the target and damaging it
/datum/wargame_unit_stats/proc/good_hit_voiceline()
	var/list/lines = list(
		"Confirming good hits [commander].",
		"[capitalize(commander)]! We hit them! Good effect on target!",
		"Yes, a hit!",
	)
	return pick(lines)

/// Calculates the ship's armor class based on cover on the same tile
/datum/wargame_unit_stats/proc/calculate_armor_class(obj/hologram)
	var/cover_modifier = 0
	var/turf/cover_turf = get_turf(hologram)
	for(var/obj/structure/wargame_hologram/cover_hologram in cover_turf.contents)
		if(cover_hologram.unit_stats.unit_size > unit_size)
			cover_modifier++
	return armor_class + min(cover_modifier, WARGAME_MAX_COVER_BONUS)

/// Calculates the ship's evasion bonus based on evasion boosters in the tile
/datum/wargame_unit_stats/proc/calculate_evasion_mod(obj/hologram)
	var/evasion_modifier = 0
	var/turf/evasion_turf = get_turf(hologram)
	for(var/obj/structure/wargame_hologram/evasion_hologram in evasion_turf.contents)
		if(evasion_hologram.unit_stats.unit_size == WARGAME_EVASION_BONUS)
			evasion_modifier++
	return evasion_modifier + min(evasion_modifier, WARGAME_MAX_EVASION_BONUS)

/// Pulls up an 8 dir radial wheel for movement, also handles checking if we have the action points to move or not
/datum/wargame_unit_stats/proc/unit_movement(mob/living/user, obj/hologram)
	if(isnull(hologram))
		return // ??
	if(movement_cost > action_points)
		hologram.balloon_alert(user, "not enough AP!")
		return
	var/picked_dir_string = show_radial_menu(user, hologram, GLOB.all_radial_directions)
	if(isnull(picked_dir_string))
		return
	var/picked_dir = text2dir(picked_dir_string)
	try_move_adjacent(hologram, picked_dir)
	action_points -= movement_cost
	post_move_effects(hologram)

/// Any effects to do post movement, like voicelines or sound effects
/datum/wargame_unit_stats/proc/post_move_effects(obj/hologram)
	if(prob(50))
		playsound(hologram, 'sound/items/radio/radio_talk.ogg', 50, TRUE)
		return
	var/list/lines = list(
		"Moving to designated coordinates.",
		"Moving to position [commander].",
		"Displacing.",
		"Getting there.",
		"Starting burn.",
		"Move order ackowledged.",
		"Course set [commander].",
		"Coordinates dialed in.",
	)
	if(talkative)
		hologram.say("[pick(lines)]")
	playsound(hologram, 'sound/items/radio/radio_receive.ogg', 50, TRUE)

/datum/wargame_unit_stats/generic
	unit_class = "Generic Thing"
	generates_name = TRUE
	unit_name = "Unidentified Thing"
	conditions_limit = 2
	possible_conditions = list(
		/datum/wargame_condition/hull_damage,
	)
	armor_class = 5
	evasion_modifier = 0
	movement_cost = 1
	maximum_action_points = 3
	unit_size = WARGAME_SIZE_MEDIUM
	weaponry = list(
		/datum/wargame_weapon/medium_cannon,
		/datum/wargame_weapon/pdc,
	)
