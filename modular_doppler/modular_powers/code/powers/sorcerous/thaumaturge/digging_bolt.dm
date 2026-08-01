/datum/power/thaumaturge/digging_bolt
	name = "Digging Bolt"
	desc = "Fires a blast of arcane power which can destroy rock, but does no damage to creatures. \
	\nRequires Affinity 2."
	security_record_text = "Subject can conjure kinetic blasts similar to those created by excavation tools."
	security_threat = POWER_THREAT_MINOR
	value = 4

	action_path = /datum/action/cooldown/power/thaumaturge/digging_bolt
	required_powers = list(/datum/power/thaumaturge_root)
	required_allow_subtypes = TRUE

/datum/action/cooldown/power/thaumaturge/move_earth
	name = "Digging Bolt"
	desc = "Fires a blast of arcane power which can destroy rock."
	button_icon = 'icons/obj/mining.dmi'
	button_icon_state = "pickaxe"

	max_charges = 10
	required_affinity = 2
	prep_cost = 2
	click_to_activate = TRUE
	anti_magic_on_target = FALSE

// How mining skill affects how many digging bolts you have.
skill_modifier = carbon_firer.mind.get_skill_modifier(/datum/skill/mining, SKILL_LVL)

/// It's the amount of digging bolts you have remaining.
	var/bolts_remaining = 0

/datum/action/cooldown/power/thaumaturge/digging_bolt/use_action(mob/living/user, atom/target)
	// Toggle the bolt firing mode.
	if(active)
		disable_bolts(user, span_warning("You dispel the digging bolts."))
		return FALSE

	if(user != owner)
		return FALSE

	active = TRUE
	bolts_remaining = clamp(affinity + skill_modifier * 2, 3, 30)

	RegisterSignal(owner, COMSIG_MOB_CLICKON, PROC_REF(on_owner_clickon))
	to_chat(owner, span_notice("You swell with rockin' power! Left click to fire one of your "))
	return TRUE
/// Tells the game what to do when you click stuff.
/datum/action/cooldown/power/thaumaturge/digging_bolt/proc/on_owner_clickon(mob/living/clicker, atom/target, params)
	SIGNAL_HANDLER

	if(!active)
		return
	if(clicker != owner)
		return
	if(bolts_remaining <= 0)
		disable_barrage(owner, null)
		return

	// Forbids digging yourself, because you're probably not a rock.
	if(target == owner)
		return

	// Params may already be a list (depends on the signal source). I'm scared to touch this part because I don't understand it.
	var/list/modifiers
	if(islist(params))
		modifiers = params
	else
		modifiers = params2list(params)

	// Left click to fire a digging bolt.
	if(fire_single_shot(owner, target))
		missiles_remaining--
		if(missiles_remaining <= 0)
			disable_barrage(owner, null)


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
