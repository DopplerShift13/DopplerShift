/*
	Swing your tail!
*/
/datum/power/aberrant/tailsweep
	name = "Tail Sweep"
	desc = "Your tail is a weapon in its own right. When activated, damages all creatures adjacent to you for 10 brute and 20 stamina, and knocks them away 2 spaces, potentially into walls.\
	\n Has a short cooldown, consumes hunger. Requires a tail."
	security_record_text = "Subject can use their tail to damage and knock back foes in active combat."
	security_threat = POWER_THREAT_MAJOR
	value = 3

	required_powers = list(/datum/power/aberrant_root/beastial)
	action_path = /datum/action/cooldown/power/aberrant/tailsweep

	// Hunger cost of the power
	var/hunger_cost = 10

/datum/action/cooldown/power/aberrant/tailsweep
	name = "Tail Sweep"
	desc = "Your tail is a weapon in its own right. When activated, damages all creatures adjacent to you for 10 brute and 20 stamina, and knocks them away 2 spaces, potentially into walls."
	button_icon = 'icons/mob/actions/actions_xeno.dmi'
	button_icon_state = "tailsweep"
	cooldown_time = 10 SECONDS

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
	for(var/mob/living/victim in oview(1, user))
		to_chat(victim, span_userdanger("[user] knocks you back with their tail!"))
		victim.adjustBruteLoss(10)
		victim.adjustStaminaLoss(20)
		if(victim.anchored)
			continue
		var/dir_to_victim = get_dir(user, victim)
		var/turf/throw_target = get_ranged_target_turf(victim, dir_to_victim, 2)
		if(throw_target)
			victim.throw_at(throw_target, 2, 1, thrower = user, force = MOVE_FORCE_STRONG)
	return TRUE

/datum/action/cooldown/power/aberrant/shapechange/on_action_success(mob/living/user, atom/target)
	if(iscarbon(user))
		user.adjust_nutrition(-hunger_cost)
