/*
	Swing your tail!
*/
/datum/power/aberrant/tailsweep
	name = "Tail Sweep"
	desc = "Your tail is a weapon in its own right. When activated, damages all creatures adjacent to you for 20 brute and 30 stamina, and knocks them away 2 spaces, potentially into walls.\
	\n Has a short cooldown, consumes hunger and the damage is affected by your opponent's chest armor. Requires a tail. If you are a large mob (such as with the Oversized quirk), you gain +1 range."
	security_record_text = "Subject can use their tail to damage and knock back foes in active combat."
	security_threat = POWER_THREAT_MAJOR
	value = 4

	required_powers = list(/datum/power/aberrant_root/beastial)
	action_path = /datum/action/cooldown/power/aberrant/tailsweep

/datum/action/cooldown/power/aberrant/tailsweep
	name = "Tail Sweep"
	desc = "Your tail is a weapon in its own right. When activated, damages all creatures adjacent to you for 20 brute and 30 stamina, and knocks them away 2 spaces, potentially into walls."
	button_icon = 'icons/mob/actions/actions_xeno.dmi'
	button_icon_state = "tailsweep"
	cooldown_time = 6 SECONDS

	/// Base range.
	var/range = 1
	/// Throw distance
	var/throw_dist = 2
	/// Hunger cost of the power
	var/hunger_cost = 10
	/// How much brute damage it deals
	var/damage = 20
	/// How much stam damage it deals
	var/stam_damage = 30
	/// Path of the effect that appears when you get smacked by the tail
	var/on_hit_vfx = /obj/effect/temp_visual/dir_setting/tailsweep

/datum/action/cooldown/power/aberrant/tailsweep/can_use(mob/living/user, atom/target)
	if(iscarbon(user)) // we don't check for tails on non-carbons; I figured it should only exist on others for admeme reasons.
		var/mob/living/carbon/carbon_user = user
		var/obj/item/organ/tail/tail = carbon_user.get_organ_slot(ORGAN_SLOT_EXTERNAL_TAIL)
		if(!tail)
			owner.balloon_alert(user, "no tail")
			return FALSE
	if(user.nutrition <= NUTRITION_LEVEL_STARVING) // can't use while starving
		owner.balloon_alert(user, "too hungry!")
		return FALSE
	. = ..()

/datum/action/cooldown/power/aberrant/tailsweep/use_action(mob/living/user, atom/target)
	playsound(get_turf(user), 'sound/effects/magic/tail_swing.ogg', 80, TRUE, MEDIUM_RANGE_SOUND_EXTRARANGE)
	user.visible_message(user, span_danger("[user] swings their tail aggressively in an arc around themselves!"))
	user.spin(0.6 SECONDS, 1)
	// checks if the mob is large; if so +1 to distance.
	var/effective_range = range + ((user.mob_size >= MOB_SIZE_LARGE) ? 1 : 0)
	for(var/mob/living/victim in oview(effective_range, user))
		// feedback
		to_chat(victim, span_userdanger("[user] knocks you back with their tail!"))
		new on_hit_vfx(get_turf(victim), get_dir(user, victim))

		// damaging. The reason why we complicate this is because we want it to be affected by body armour.
		var/dmg_dealt = victim.apply_damage(damage, BRUTE, BODY_ZONE_CHEST, victim.run_armor_check(BODY_ZONE_CHEST, MELEE))
		var/stam_dmg_dealt = victim.apply_damage(stam_damage, STAMINA, BODY_ZONE_CHEST, victim.run_armor_check(BODY_ZONE_CHEST, MELEE))

		// logging
		victim.log_message("was tail-sweeped by [user] for [dmg_dealt] brute damage and [stam_dmg_dealt] stamina damage.", LOG_VICTIM)
		user.log_message("has tail-sweeped [victim] for [dmg_dealt] brute damage and [stam_dmg_dealt] stamina damage.", LOG_ATTACK)

		// throwing
		if(victim.anchored)
			continue
		var/dir_to_victim = get_dir(user, victim)
		var/turf/throw_target = get_ranged_target_turf(victim, dir_to_victim, 2)
		if(throw_target)
			victim.throw_at(throw_target, throw_dist, 1, thrower = user, force = MOVE_FORCE_STRONG)
	return TRUE

/datum/action/cooldown/power/aberrant/shapechange/on_action_success(mob/living/user, atom/target)
	if(iscarbon(user))
		user.adjust_nutrition(-hunger_cost)
