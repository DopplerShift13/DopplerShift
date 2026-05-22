/datum/wargame_unit_stats
	abstract_type = /datum/wargame_unit_stats
	/// The class of unit, "missile destroyer" or "asteroid" as examples
	var/unit_class
	/// Does this unit generate a random name for itself? Use only on ships
	var/generates_name = FALSE
	/// This unit's name, automatically generated or set manually. Can be null for no special name
	var/unit_name
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
	/// Associative list of weapon to radial choice, should be a list of weapons on init
	var/list/weaponry = list()

/datum/wargame_unit_stats/New()
	set_up_weaponry()

/// Sets up weapon datums and radial options
/datum/wargame_unit_stats/proc/set_up_weaponry()
	if(!length(weaponry))
		return // We just don't have weapons
	var/list/temporary_weapons = list()
	for(var/datum/wargame_weapon/weapon as anything in weaponry)
		var/datum/radial_menu_choice/choice = new()
		choice.name = weapon.weapon_name
		choice.icon = image(icon = WARGAME_ACTIONS_FILE, icon_state = weapon.radial_icon_state)
		choice.info = weapon.weapon_description()
		temporary_weapons[weapon] = choice

/// Sets our action points back to max
/datum/wargame_unit_stats/proc/make_ready()
	action_points = maximum_action_points

/// Runs through everything we might need to process during the effects phase
/datum/wargame_unit_stats/proc/effects_phase_process()
	for(var/datum/wargame_condition/condition as anything in current_conditions)
		condition.condition_lifetime_left--
		if(condition.condition_lifetime_left <= 0)
			condition.removed_from_unit()
			current_conditions -= condition
			qdel(condition)

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
		WARGAME_UNIT_SPECIAL = image(icon = WARGAME_ACTIONS_FILE, icon_state = "unit_special"),
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
	if(!weapon_choice.prefire_checks(user, src))
		return
	if(!weapon_choice.all_special_effects)
		target_hologram.get_attacked(user, hologram, weapon_choice)
	weapon_choice.special_effects_fire(user, src)

/// Calculates getting attacked
/datum/wargame_unit_stats/proc/get_attacked(mob/living/user, obj/hologram, datum/wargame_weapon/weapon_used)
	if(isnull(weapon_used))
		return
	var/incoming_attack_roll = roll(weapon_used.attack_roll)
	if(is_small_vessel && weapon_used.small_ship_disadvantage)
		incoming_attack_roll = min(incoming_attack_roll, roll(weapon_used.attack_roll))
	var/total_armor_class = weapon_used.evadable ? (armor_class + evasion_modifier) : armor_class
	if(incoming_attack_roll <= incoming_attack_roll)
		return
	if((incoming_attack_roll + weapon_used.damage_roll_bonus) <= armor_class)
		return // If our weapon is weak (PDC) then it makes our attack roll less than armor class
	var/datum/wargame_condition/new_condition = pick(possible_conditions)
	new_condition = new()
	new_condition.applied_to_unit(src)
	current_conditions += new_condition

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
	hologram.say("Moving to location.")

/datum/wargame_unit_stats/generic
	unit_class = "Generic Thing"
	generates_name = FALSE
	unit_name = "Unidentified Thing"
	conditions_limit = 2
	possible_conditions = list(
		/datum/wargame_condition/hull_damage,
	)
	armor_class = 5
	evasion_modifier = 0
	movement_cost = 1
	maximum_action_points = 3
	weaponry = list(
		/datum/wargame_weapon/medium_cannon,
		/datum/wargame_weapon/pdc,
		/datum/wargame_weapon/minefield,
	)
