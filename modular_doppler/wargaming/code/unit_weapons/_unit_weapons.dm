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
	var/small_ship_disadvantage = FALSE
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

/// Returns a string for a ship to say when firing the weapon
/datum/wargame_weapon/proc/firing_voiceline()
	return

/// Plays a firing sound for the weapon
/datum/wargame_weapon/proc/weapon_firing_sound(obj/firer)
	return

/// Plays a firing sound for the weapon
/datum/wargame_weapon/proc/weapon_firing_message(obj/firer, obj/target)
	return

/// By default, checks in a circle range around the ship for another hologram to target
/datum/wargame_weapon/proc/pick_target(mob/living/user, obj/structure/wargame_hologram/hologram)
	var/datum/wargaming_team/hologram_team = hologram.team_reference?.resolve()
	var/list/potential_targets = list()
	for(var/obj/structure/wargame_hologram/other_hologram in view(attack_range, hologram))
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
/datum/wargame_weapon/proc/special_effects_fire(mob/living/user, datum/wargame_unit_stats/stats, obj/structure/wargame_hologram/hologram, obj/structure/wargame_hologram/target_hologram, impact)
	stats.action_points -= action_point_cost
	if(isnull(maximum_ammo))
		return
	maximum_ammo--

// Generic ramming weapon for missiles
/datum/wargame_weapon/ramming
	abstract_type = /datum/wargame_weapon/ramming
	weapon_name = "Ramming Speed"
	attack_range = 1
	radial_icon_state = "weapon_ram"

/datum/wargame_weapon/ramming/special_effects_fire(mob/living/user, datum/wargame_unit_stats/stats, obj/structure/wargame_hologram/hologram, obj/structure/wargame_hologram/target_hologram, impact)
	if(impact)
		stats.im_boutta_blow(hologram)

// Generic missile launch weapon
/datum/wargame_weapon/missile
	abstract_type = /datum/wargame_weapon/missile
	attack_range = 7
	all_special_effects = TRUE
	/// The type of missile hologram this should spawn when running an attack outside of short range
	var/obj/structure/wargame_hologram/missile_type

/datum/wargame_weapon/missile/special_effects_fire(mob/living/user, datum/wargame_unit_stats/stats, obj/structure/wargame_hologram/hologram, obj/structure/wargame_hologram/target_hologram, impact)
	if(!target_hologram)
		return // ??
	if(get_dist(hologram, target_hologram) <= 1)
		target_hologram.unit_stats.get_attacked(user, hologram, target_hologram, src)
		return ..()
	var/dir_to_target = get_dir(hologram, target_hologram)
	var/obj/structure/wargame_hologram/new_missile = new missile_type(get_turf(hologram), hologram.projector)
	new_missile.team_reference = hologram.team_reference
	new_missile.color = hologram.color
	new_missile.update_appearance()
	try_move_adjacent(new_missile, dir_to_target)
	return ..()
