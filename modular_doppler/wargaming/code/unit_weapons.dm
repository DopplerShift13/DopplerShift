/datum/wargame_weapon
	abstract_type = /datum/wargame_weapon
	/// The name of the weapon
	var/weapon_name
	/// The attack roll of the weapon if within range
	var/attack_roll
	/// A negative number to make weapons that are weak to armor less effective against high armor class
	var/damage_roll_bonus
	/// The weapon range in tiles, 0 is the same tile as the ship firing it
	var/attack_range
	/// If this attack can be evaded, giving ships with an evasion bonus extra armor class
	var/evadable
	/// If this weapon has roll disadvantage against small ships
	var/small_ship_disadvantage
	/// The icon_state to use for this weapon's radial menu option
	var/radial_icon_state
	/// If this weapon has a limited number of uses before needing to be re-armed
	var/maximum_ammo
	/// How many action points this weapon costs to fire
	var/action_point_cost
	/// If this weapon's attack is handled entirely by special_effects_fire()
	var/all_special_effects = FALSE

/// Returns a string to describe the weapon
/datum/wargame_weapon/proc/weapon_description()
	return

/// By default, checks in a circle range around the ship for another hologram to target
/datum/wargame_weapon/proc/pick_target(mob/living/user, obj/structure/wargame_hologram/hologram)
	var/datum/wargaming_team/hologram_team = hologram.team_reference?.resolve()
	var/list/potential_targets = list()
	for(var/obj/structure/wargame_hologram/other_hologram in range(attack_range))
		if(!other_hologram.unit_stats.can_be_a_target)
			continue
		if(isnull(hologram_team))
			potential_targets += other_hologram
			continue // If we have no team then free for all everything's a target
		var/datum/wargaming_team/other_hologram_team = other_hologram.team_reference?.resolve()
		if(other_hologram_team == hologram_team)
			continue // Cannot target friendlies otherwise
		potential_targets += other_hologram
	if(!length(potential_targets))
		hologram.balloon_alert(user, "no targets!")
		return
	var/picked_target = tgui_input_list(user, "Pick a target within range.", "Target Picker", potential_targets)
	if(isnull(picked_target))
		hologram.balloon_alert(user, "no choice!")
		return
	return picked_target

/// If this weapon has any special pre-fire checks
/datum/wargame_weapon/proc/prefire_checks(mob/living/user, datum/wargame_unit_stats/stats, obj/structure/wargame_hologram/hologram)
	if(stats.action_points < action_point_cost)
		hologram.balloon_alert(user, "not enough AP!")
		return FALSE
	if(isnull(maximum_ammo))
		return TRUE
	if(maximum_ammo <= 0)
		hologram.balloon_alert(user, "no ammo!")
		return FALSE
	return TRUE

/// If this weapon does anything special when initially firing
/datum/wargame_weapon/proc/special_effects_fire(mob/living/user, obj/structure/wargame_hologram/hologram)
	if(isnull(maximum_ammo))
		return
	maximum_ammo--

/datum/wargame_weapon/mass_driver
	weapon_name = "Mass Driver"
	attack_roll = "2d10+4"
	damage_roll_bonus = 0
	attack_range = 3
	evadable = TRUE
	small_ship_disadvantage = TRUE
	radial_icon_state = "weapon_guns_big"
	action_point_cost = 1

/datum/wargame_weapon/mass_driver/weapon_description()
	return "A large mass driver for launching hardened cores at large targets. Max range of [attack_range] tiles. [action_point_cost] AP to fire."

/datum/wargame_weapon/large_cannon
	weapon_name = "7\" Cannon"
	attack_roll = "2d16+4"
	damage_roll_bonus = 0
	attack_range = 2
	evadable = TRUE
	small_ship_disadvantage = TRUE
	radial_icon_state = "weapon_guns_big"
	action_point_cost = 1

/datum/wargame_weapon/large_cannon/weapon_description()
	return "A large calibre 7 in. cannon for launching shells at large targets. Max range of [attack_range] tiles. [action_point_cost] AP to fire."

/datum/wargame_weapon/medium_cannon
	weapon_name = "2.5\" Cannon"
	attack_roll = "4d5+4"
	damage_roll_bonus = 0
	attack_range = 2
	evadable = TRUE
	small_ship_disadvantage = TRUE
	radial_icon_state = "weapon_guns_big"
	action_point_cost = 1

/datum/wargame_weapon/medium_cannon/weapon_description()
	return "A medium calibre 2.5 in. cannon fore launching shells at large targets. Max range of [attack_range] tiles. [action_point_cost] AP to fire."

/datum/wargame_weapon/rockets
	weapon_name = "Rockets"
	attack_roll = "6d4"
	damage_roll_bonus = 0
	attack_range = 2
	evadable = TRUE
	radial_icon_state = "weapon_rocket"
	action_point_cost = 1

/datum/wargame_weapon/rockets/strike
	maximum_ammo = 2

/datum/wargame_weapon/rockets/weapon_description()
	return "A barrage of unguided rockets from a fixed rack or large launcher. Max range of [attack_range] tiles. [action_point_cost] AP to fire."

/datum/wargame_weapon/bombs
	weapon_name = "Bombs"
	attack_roll = "1d20"
	damage_roll_bonus = 0
	attack_range = 1
	evadable = TRUE
	small_ship_disadvantage = TRUE
	radial_icon_state = "weapon_bomb"
	maximum_ammo = 2
	action_point_cost = 1

/datum/wargame_weapon/bombs/weapon_description()
	return "A group of unpowered explosive bombs to crack large targets. Max range of [attack_range] tiles. [action_point_cost] AP to fire."

/datum/wargame_weapon/minefield
	weapon_name = "Mines"
	attack_roll = "3d8"
	damage_roll_bonus = 0
	attack_range = 0
	evadable = TRUE
	radial_icon_state = "weapon_mine"
	maximum_ammo = 6
	action_point_cost = 2

/datum/wargame_weapon/minefield/weapon_description()
	return "A dense field of mines that only allow friendly signals to pass. Will only damage ships that pass through them. [action_point_cost] AP to fire."

/datum/wargame_weapon/autocannon
	weapon_name = "45mm Autocannon"
	attack_roll = "2d10+2"
	damage_roll_bonus = 0
	attack_range = 1
	evadable = TRUE
	radial_icon_state = "weapon_guns"
	action_point_cost = 1

/datum/wargame_weapon/autocannon/weapon_description()
	return "Low calibre 45mm autocannons for fast moving targets. Max range of [attack_range] tiles. [action_point_cost] AP to fire."

/datum/wargame_weapon/pdc
	weapon_name = "26mm PDC"
	attack_roll = "1d12+8"
	damage_roll_bonus = -2
	attack_range = 1
	evadable = FALSE
	radial_icon_state = "weapon_guns_pdc"
	action_point_cost = 1

/datum/wargame_weapon/pdc/weapon_description()
	return "Small calibre 26mm autocannons with exceptional hit chance but low damage. Max range of [attack_range] tiles. [action_point_cost] AP to fire."

/datum/wargame_weapon/anti_ship_beam
	weapon_name = "Anti-Ship Beam"
	attack_roll = "1d20+5"
	damage_roll_bonus = 0
	attack_range = 1
	evadable = FALSE
	small_ship_disadvantage = TRUE
	radial_icon_state = "weapon_beam"
	action_point_cost = 2

/datum/wargame_weapon/anti_ship_beam/weapon_description()
	return "A high-energy beam for coring large ships with. Max range of [attack_range] tiles. [action_point_cost] AP to fire."

/datum/wargame_weapon/pd_beam
	weapon_name = "PD Beam"
	attack_roll = "1d20+6"
	damage_roll_bonus = -4
	attack_range = 2
	evadable = FALSE
	radial_icon_state = "weapon_pd_beam"
	action_point_cost = 1

/datum/wargame_weapon/pd_beam/weapon_description()
	return "Highly focused beams with exceptional hit chance but low damage. Max range of [attack_range] tiles. [action_point_cost] AP to fire."
