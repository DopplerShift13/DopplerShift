#define KICK_COMBO "HH"
#define BRACED_THROW_COMBO "DHD"
#define CONSECUTIVE_COMBO "HDH"

/datum/martial_art/mad_dog
	name = "The Mad Dog's Style"
	id = MARTIALART_MAD_DOG
	help_verb = /mob/living/proc/mad_dog_help
	smashes_tables = TRUE
	display_combos = TRUE
	grab_state_modifier = 1
	grab_damage_modifier = 5
	/// Weakref for our stun absorption status effect, to reference the vars it uses
	var/datum/weakref/stun_absorption_ref
	/// Probability of successfully blocking attacks
	var/block_chance = 20
	/// List of traits applied/taken away on gain/loss; similar to sleeping carp but with a focus on survival instead of supernatural bullet deflection
	var/list/mad_dog_traits = list(TRAIT_NOGUNS, TRAIT_TOSS_GUN_HARD, TRAIT_HARDLY_WOUNDED, TRAIT_NODISMEMBER, TRAIT_PUSHIMMUNE, TRAIT_NOSOFTCRIT)

/datum/martial_art/mad_dog/activate_style(mob/living/new_holder)
	. = ..()
	new_holder.add_traits(mad_dog_traits, MAD_DOG_TRAIT)
	RegisterSignal(new_holder, COMSIG_LIVING_CHECK_BLOCK, PROC_REF(check_block))
	RegisterSignal(new_holder, COMSIG_MOVABLE_MOVED, PROC_REF(on_movement))
	new_holder.AddComponent(/datum/component/unbreakable)
	var/datum/status_effect/stun_absorption/martial_stun_res = new_holder.add_stun_absorption(
		source = name,
		priority = 3, // arbitrary
		max_seconds_of_stuns_blocked = 3 SECONDS, // lock the fuck in
		delete_after_passing_max = FALSE,
		recharge_time = 20 SECONDS,
		message = span_boldwarning("%EFFECT_OWNER pushes through the stun!"),
		self_message = span_boldwarning("You shrug off the debilitating attack!")
	)
	stun_absorption_ref = WEAKREF(martial_stun_res)

/datum/martial_art/mad_dog/deactivate_style(mob/living/remove_from)
	remove_from.remove_traits(mad_dog_traits, MAD_DOG_TRAIT)
	remove_from.RemoveComponentSource(REF(src), /datum/component/unbreakable)
	remove_from.remove_stun_absorption(name)
	UnregisterSignal(remove_from, list(COMSIG_ATOM_ATTACKBY, COMSIG_LIVING_CHECK_BLOCK))
	UnregisterSignal(remove_from, list(COMSIG_MOVABLE_MOVED))
	stun_absorption_ref = null
	return ..()

/datum/martial_art/mad_dog/proc/check_block(mob/living/mad_dog_user, atom/movable/hitby, damage, attack_text, attack_type, ...)
	SIGNAL_HANDLER

	if(!can_use(mad_dog_user) || !mad_dog_user.combat_mode || INCAPACITATED_IGNORING(mad_dog_user, INCAPABLE_GRAB))
		return NONE
	if(attack_type == PROJECTILE_ATTACK)
		return NONE
	if(!prob(block_chance + mad_dog_user.throw_mode * 25)) // 45% chance to block melee with throw mode on, 70% chance if you're holding down throwmode and not hitting any other key
		return NONE

	var/mob/living/attacker = GET_ASSAILANT(hitby)
	if(istype(attacker) && mad_dog_user.Adjacent(attacker))
		mad_dog_user.visible_message(
			span_danger("[mad_dog_user] deflects [attack_text] with [mad_dog_user.p_their()] defensive stance!"),
			span_userdanger("You deflect [attack_text]!"),
		)
		playsound(attacker.loc, 'sound/items/weapons/block_shield.ogg', 70, TRUE, SHORT_RANGE_SOUND_EXTRARANGE)
		INVOKE_ASYNC(attacker, TYPE_PROC_REF(/atom, Shake), 1, 0, 0.25 SECONDS)
	else
		mad_dog_user.visible_message(
			span_danger("[mad_dog_user] blocks [attack_text]!"),
			span_userdanger("You block [attack_text]!"),
		)
	return SUCCESSFUL_BLOCK

/datum/martial_art/mad_dog/proc/check_streak(mob/living/attacker, mob/living/defender)
	if(findtext(streak, KICK_COMBO))
		reset_streak()
		return Kick(attacker, defender)
	if(findtext(streak, BRACED_THROW_COMBO))
		reset_streak()
		return braceThrow(attacker, defender)
	if(findtext(streak, CONSECUTIVE_COMBO))
		reset_streak()
		return Consecutive(attacker, defender)
	return FALSE

/datum/martial_art/mad_dog/proc/Kick(mob/living/attacker, mob/living/defender)
	defender.visible_message(
		span_danger("[attacker] kicks [defender] back!"),
		span_userdanger("You're kicked back by [attacker]!"),
		span_hear("You hear a sickening sound of flesh hitting flesh!"),
		COMBAT_MESSAGE_RANGE,
		attacker,
	)
	to_chat(attacker, span_danger("You kick [defender] back!"))
	playsound(attacker, 'sound/items/weapons/cqchit1.ogg', 50, TRUE, -1)
	var/atom/throw_target = get_edge_target_turf(defender, attacker.dir)
	defender.throw_at(throw_target, 2, 14, attacker, spin = FALSE, gentle = TRUE)
	defender.apply_damage(15, attacker.get_attack_type())
	if(defender.body_position == LYING_DOWN && !defender.IsUnconscious())
		defender.adjustStaminaLoss(15)
	log_combat(attacker, defender, "center kicked (Mad Dog)")
	return TRUE

/datum/martial_art/mad_dog/proc/braceThrow(mob/living/attacker, mob/living/defender)
	attacker.do_attack_animation(defender, ATTACK_EFFECT_KICK)
	defender.visible_message(
		span_warning("[attacker] braces themselves, grabbing [defender] and tossing them with inhuman strength!"),
		span_userdanger("You are grappled and tossed like a ragdoll by [attacker]!"),
		span_hear("You hear the sound of a struggle, followed by a crashing noise!"),
		COMBAT_MESSAGE_RANGE,
		attacker,
	)
	playsound(attacker, 'sound/effects/hit_kick.ogg', 50, TRUE, -1)
	var/atom/throw_target = get_edge_target_turf(defender, attacker.dir)
	defender.throw_at(throw_target, 7, 4, attacker, spin = FALSE)
	defender.apply_damage(15, attacker.get_attack_type(), BODY_ZONE_CHEST, wound_bonus = CANT_WOUND)
	log_combat(attacker, defender, "brace kicked (Mad Dog)")
	return TRUE

/datum/martial_art/mad_dog/proc/Consecutive(mob/living/attacker, mob/living/defender)
	if(defender.stat != CONSCIOUS)
		return FALSE

	attacker.do_attack_animation(defender)
	log_combat(attacker, defender, "combo striked (Mad Dog)")
	defender.visible_message(
		span_danger("[attacker] strikes [defender]'s abdomen, neck and back consecutively"), \
		span_userdanger("Your abdomen, neck and back are struck consecutively by [attacker]!"),
		span_hear("You hear a sickening sound of flesh hitting flesh!"),
		COMBAT_MESSAGE_RANGE,
		attacker,
	)
	to_chat(attacker, span_danger("You strike [defender]'s abdomen, neck and back consecutively!"))
	playsound(defender, 'sound/items/weapons/cqchit2.ogg', 50, TRUE, -1)
	defender.adjustStaminaLoss(50)
	defender.apply_damage(25, attacker.get_attack_type())
	return TRUE

/datum/martial_art/mad_dog/grab_act(mob/living/attacker, mob/living/defender)
	if(attacker == defender)
		return MARTIAL_ATTACK_INVALID

	if(defender.check_block(attacker, 0, attacker.name, UNARMED_ATTACK))
		return MARTIAL_ATTACK_FAIL

	add_to_streak("G", defender)
	if(check_streak(attacker, defender)) //if a combo is made no grab upgrade is done
		return MARTIAL_ATTACK_SUCCESS

	if(attacker.body_position == LYING_DOWN)
		return MARTIAL_ATTACK_INVALID

	log_combat(attacker, defender, "grabbed (Mad Dog)")
	return MARTIAL_ATTACK_INVALID

/datum/martial_art/mad_dog/harm_act(mob/living/attacker, mob/living/defender)
	if(attacker.grab_state == GRAB_KILL \
		&& attacker.zone_selected == BODY_ZONE_HEAD \
		&& attacker.pulling == defender \
		&& defender.stat != DEAD \
	)
		var/obj/item/bodypart/head = defender.get_bodypart(BODY_ZONE_HEAD)
		if(!isnull(head))
			defender.visible_message(
				span_danger("[attacker] secures their grip around [defender]'s head..."),
				span_userdanger("[attacker] grabs your head and begins to twist..."),
				span_hear("You hear a violent struggle..."),
				ignored_mobs = attacker
			)
			to_chat(attacker, span_danger("You carefully secure your grip around [defender]'s head and twist..."))
			if(!do_after(attacker, 8 SECONDS, target = defender)) // takes time to do a neck snap
				return
			playsound(defender, 'sound/effects/wounds/crack1.ogg', 100)
			defender.visible_message(
				span_danger("[attacker] snaps the neck of [defender]!"),
				span_userdanger("Your neck is snapped by [attacker]!"),
				span_hear("You hear a sickening snap!"),
				ignored_mobs = attacker
			)
			to_chat(attacker, span_danger("In a brutal motion, you snap the neck of [defender]!"))
			log_combat(attacker, defender, "snapped neck")
			defender.apply_damage(100, BRUTE, BODY_ZONE_HEAD, wound_bonus=CANT_WOUND)
			if(!HAS_TRAIT(defender, TRAIT_NODEATH))
				defender.death()
				defender.investigate_log("has had [defender.p_their()] neck snapped by [attacker].", INVESTIGATE_DEATHS)
			return MARTIAL_ATTACK_SUCCESS

	if(defender.check_block(attacker, 10, attacker.name, UNARMED_ATTACK))
		return MARTIAL_ATTACK_FAIL

	if(attacker.resting && defender.stat != DEAD && defender.body_position == STANDING_UP)
		defender.visible_message(
			span_danger("[attacker] leg sweeps [defender]!"),
			span_userdanger("Your legs are sweeped by [attacker]!"),
			span_hear("You hear a sickening sound of flesh hitting flesh!"),
			null,
			attacker,
		)
		to_chat(attacker, span_danger("You leg sweep [defender]!"))
		playsound(attacker, 'sound/effects/hit_kick.ogg', 50, TRUE, -1)
		attacker.do_attack_animation(defender)
		defender.apply_damage(10, BRUTE)
		defender.Knockdown(5 SECONDS)
		log_combat(attacker, defender, "sweeped (Mad Dog)")
		reset_streak()
		return MARTIAL_ATTACK_SUCCESS

	add_to_streak("H", defender)
	if(check_streak(attacker, defender))
		return MARTIAL_ATTACK_SUCCESS
	attacker.do_attack_animation(defender)
	var/picked_hit_type = pick("deftly punch", "precisely kick")
	var/bonus_damage = 13
	if(defender.body_position == LYING_DOWN)
		bonus_damage += 5
		picked_hit_type = pick("crazedly kick", "brutally stomp")
	defender.apply_damage(bonus_damage, BRUTE)

	playsound(defender, (picked_hit_type == "kick" || picked_hit_type == "stomp") ? 'sound/items/weapons/cqchit2.ogg' : 'sound/items/weapons/cqchit1.ogg', 50, TRUE, -1)

	defender.visible_message(
		span_danger("[attacker] [picked_hit_type]ed [defender]!"),
		span_userdanger("You're [picked_hit_type]ed by [attacker]!"),
		span_hear("You hear a sickening sound of flesh hitting flesh!"),
		COMBAT_MESSAGE_RANGE,
		attacker,
	)
	to_chat(attacker, span_danger("You [picked_hit_type] [defender]!"))
	log_combat(attacker, defender, "attacked ([picked_hit_type]'d)(Mad Dog)")
	return MARTIAL_ATTACK_SUCCESS

/datum/martial_art/mad_dog/disarm_act(mob/living/attacker, mob/living/defender)
	if(defender.check_block(attacker, 0, attacker.name, UNARMED_ATTACK))
		return MARTIAL_ATTACK_FAIL

	add_to_streak("D", defender)
	if(check_streak(attacker, defender))
		return MARTIAL_ATTACK_SUCCESS

	attacker.do_attack_animation(defender, ATTACK_EFFECT_DISARM)
	if(defender.stat == CONSCIOUS && !defender.IsParalyzed() && attacker.combat_mode)
		var/obj/item/disarmed_item = defender.get_active_held_item()
		if(disarmed_item && defender.temporarilyRemoveItemFromInventory(disarmed_item) && prob(20))
			attacker.put_in_hands(disarmed_item)
		else
			disarmed_item = null
		defender.visible_message(
			span_danger("[attacker] strikes [defender]'s jaw with their hand[disarmed_item ? ", disarming [defender.p_them()] of [disarmed_item]" : ""]!"),
			span_userdanger("[attacker] strikes your jaw,[disarmed_item ? " disarming you of [disarmed_item] and" : ""] leaving you disoriented!"),
			span_hear("You hear a sickening sound of flesh hitting flesh!"),
			COMBAT_MESSAGE_RANGE,
			attacker,
		)
		to_chat(attacker, span_danger("You strike [defender]'s jaw,[disarmed_item ? " disarming [defender.p_them()] of [disarmed_item] and" : ""] leaving [defender.p_them()] disoriented!"))
		playsound(defender, 'sound/items/weapons/cqchit1.ogg', 50, TRUE, -1)
		defender.set_jitter_if_lower(4 SECONDS)
		defender.apply_damage(5, attacker.get_attack_type())
		log_combat(attacker, defender, "disarmed (Mad Dog)", addition = disarmed_item ? "(disarmed of [disarmed_item])" : null)
		return MARTIAL_ATTACK_SUCCESS

/datum/martial_art/mad_dog/proc/on_movement(mob/living/carbon/user, atom/previous_loc) // fading trail effect when in combat with stun res active
	SIGNAL_HANDLER
	if(!user.combat_mode || !user.combat_indicator || user.IsParalyzed() || !user.stat == CONSCIOUS)
		return
	var/datum/status_effect/stun_absorption/stun_absorption = stun_absorption_ref.resolve()
	if(isnull(stun_absorption))
		return
	if(!stun_absorption.can_absorb_stun())
		return
	new /obj/effect/temp_visual/decoy/fading/halfsecond(previous_loc, user)

/mob/living/proc/mad_dog_help()
	set name = "Remember Your Teachings"
	set desc = "Recall the core tenets of The Mad Dog's Style."
	set category = "The Mad Dog's Style"

	to_chat(usr, "<b><i>You remember the core tenets of The Mad Dog's Style...</i></b>\n\
	[span_notice("Center Kick")]: Punch Punch. Knocks an opponent away and deals reliable damage.\n\
	[span_notice("Braced Throw")]: Shove Punch Shove. Sends opponents flying away into walls or other objects, like tables and people.\n\
	[span_notice("Combo Strike")]: Punch Shove Punch. Primary offensive move, massive damage and some stamina damage.\n\
	[span_notice("Neck Snap")]: Once you're choking someone, you can target their head and attack to snap their neck in one easy motion.\n\
	[span_notice("Deflective Palm")]: While on combat mode, you possess a 20% chance to deflect melee attacks, boosted to 45% on throw mode and 70% while holding down throw mode, and your shoves have a low chance of disarming your foe.") // inversion of scarp's ranged resistance

	to_chat(usr, "<b><i>Furthermore, you will only fall when entering hardcrit, will occasionally heal when extremely close to death, and can absorb stuns up to a limit, after which you must wait 20 seconds before absorbing more.</i></b>")

#undef KICK_COMBO
#undef BRACED_THROW_COMBO
#undef CONSECUTIVE_COMBO
