/datum/power/thaumaturge/digging_bolt
	name = "Digging Bolt"
	desc = "Fires a blast of arcane power which can destroy rock, but does no damage to creatures. \
	\nRequires Affinity 2."
	security_record_text = "Subject can conjure kinetic blasts similar to those created by excavation tools."
	security_threat = POWER_THREAT_MINOR
	value = 4

	action_path = /datum/action/cooldown/power/thaumaturge/move_earth
	required_powers = list(/datum/power/thaumaturge_root)
	required_allow_subtypes = TRUE

/datum/action/cooldown/power/thaumaturge/move_earth
	name = "Move Earth"
	desc = "Fires a blast of arcane power which can destroy rock."
	button_icon = 'icons/obj/mining.dmi'
	button_icon_state = "kineticgun"

	max_charges = 10
	required_affinity = 2
	prep_cost = 1
	click_to_activate = TRUE
	anti_magic_on_target = FALSE

	/// The projectile we fire
	var/obj/projectile/projectile_path = /obj/projectile/kinetic/miner
	cooldown_time = 2 SECONDS
	click_to_activate = TRUE
	aim_assist = FALSE // complex targeting

/datum/action/cooldown/power/thaumaturge/digging_bolt/use_action(mob/living/user, atom/target)
	if(fire_projectile(user, target, /obj/projectile/resonant/digging_bolt))
		user.visible_message(span_warning("[user] shoots a [/obj/projectile/resonant/digging_bolt::name]!"))
		playsound(user, 'sound/effects/parry.ogg', 40, TRUE, MEDIUM_RANGE_SOUND_EXTRARANGE)
		return TRUE
	return FALSE

/obj/projectile/resonant/digging_bolt
	name = "digging bolt"
	icon = 'icons/obj/weapons/guns/projectiles.dmi'
	icon_state = "green_laser"
	damage = 0
	damage_type = BRUTE
	armour_penetration = 0
	armor_flag = BOMB
	var/dist_to_tile = get_dist(tile, parent)
		if (dist_to_tile <= 2 && ismineralturf)
		var/turf/closed/mineral/M = target_turf
		M.gets_drilled(firer, 1)
