#define SLAM_COMBO "GH"
#define KICK_COMBO "HH"
#define FLYING_KICK_COMBO "HDH"
#define RESTRAIN_COMBO "GG"
#define PRESSURE_COMBO "DG"
#define CONSECUTIVE_COMBO "DDH"

/datum/martial_art/mad_dog
	name = "The Mad Dog's Style"
	id = MARTIALART_MAD_DOG
	help_verb = /mob/living/proc/mad_dog_help
	smashes_tables = TRUE
	display_combos = TRUE
	/// Weakref to a mob we're currently restraining (with grab-grab combo)
	VAR_PRIVATE/datum/weakref/restraining_mob
	/// Probability of successfully blocking attacks
	var/block_chance = 80
	/// List of traits applied/taken away on gain/loss; similar to sleeping carp but with a focus on survival instead of supernatural bullet deflection
	var/list/mad_dog_traits = list(TRAIT_NOGUNS, TRAIT_TOSS_GUN_HARD, TRAIT_HARDLY_WOUNDED, TRAIT_NODISMEMBER, TRAIT_PUSHIMMUNE, TRAIT_NOSOFTCRIT, TRAIT_NOHARDCRIT)

/datum/martial_art/mad_dog/activate_style(mob/living/new_holder)
	. = ..()
	new_holder.add_traits(mad_dog_traits, MAD_DOG_TRAIT)
	new_holder.AddComponent(/datum/component/unbreakable)
	new_holder.add_stun_absorption(
		source = name,
		priority = 3, // arbitrary
		max_seconds_of_stuns_blocked = 30 SECONDS,
		delete_after_passing_max = FALSE,
		recharge_time = 20 SECONDS,
		message = span_warning("%EFFECT_OWNER pushes through the stun!"),
		self_message = span_boldwarning("You shrug off the debilitating attack!"),
		examine_message = span_warning("%EFFECT_OWNER_THEYRE bristling with raw determination!")
	RegisterSignal(new_holder, COMSIG_ATOM_ATTACKBY, PROC_REF(on_attackby))
	RegisterSignal(new_holder, COMSIG_LIVING_CHECK_BLOCK, PROC_REF(check_block))

/datum/martial_art/mad_dog/deactivate_style(mob/living/remove_from)
	remove_from.remove_traits(mad_dog_traits, MAD_DOG_TRAIT)
	remove_from.RemoveComponentSource(REF(src), /datum/component/unbreakable)
	owner.remove_stun_absorption(name)
	UnregisterSignal(remove_from, list(COMSIG_ATOM_ATTACKBY, COMSIG_LIVING_CHECK_BLOCK))
	return ..()

///Signal from getting attacked with an item, for a special interaction with touch spells
/datum/martial_art/mad_dog/proc/on_attackby(mob/living/mad_dog_user, obj/item/attack_weapon, mob/attacker, list/modifiers)
	SIGNAL_HANDLER

	if(!istype(attack_weapon, /obj/item/melee/touch_attack))
		return
	if(!can_use(mad_dog_user))
		return
	mad_dog_user.visible_message(
		span_danger("[mad_dog_user] twists [attacker]'s arm, sending their [attack_weapon] back towards them!"),
		span_userdanger("Making sure to avoid [attacker]'s [attack_weapon], you twist their arm to send it right back at them!"),
	)
	var/obj/item/melee/touch_attack/touch_weapon = attack_weapon
	var/datum/action/cooldown/spell/touch/touch_spell = touch_weapon.spell_which_made_us?.resolve()
	if(!touch_spell)
		return
	INVOKE_ASYNC(touch_spell, TYPE_PROC_REF(/datum/action/cooldown/spell/touch, do_hand_hit), touch_weapon, attacker, attacker)
	return COMPONENT_NO_AFTERATTACK

/datum/martial_art/mad_dog/proc/check_block(mob/living/mad_dog_user, atom/movable/hitby, damage, attack_text, attack_type, ...)
	SIGNAL_HANDLER

	if(!can_use(mad_dog_user) || !mad_dog_user.throw_mode || INCAPACITATED_IGNORING(mad_dog_user, INCAPABLE_GRAB))
		return NONE
	if(attack_type == PROJECTILE_ATTACK)
		return NONE
	if(!prob(block_chance))
		return NONE

	var/mob/living/attacker = GET_ASSAILANT(hitby)
	if(istype(attacker) && mad_dog_user.Adjacent(attacker))
		mad_dog_user.visible_message(
			span_danger("[mad_dog_user] blocks [attack_text] and twists [attacker]'s arm behind [attacker.p_their()] back!"),
			span_userdanger("You block [attack_text]!"),
		)
		attacker.Stun(4 SECONDS)
	else
		mad_dog_user.visible_message(
			span_danger("[mad_dog_user] blocks [attack_text]!"),
			span_userdanger("You block [attack_text]!"),
		)
	return SUCCESSFUL_BLOCK


/datum/martial_art/mad_dog/reset_streak(mob/living/new_target)
	if(!IS_WEAKREF_OF(new_target, restraining_mob))
		restraining_mob = null
	return ..()

/datum/martial_art/mad_dog/proc/check_streak(mob/living/attacker, mob/living/defender)
	if(findtext(streak, SLAM_COMBO))
		reset_streak()
		return Slam(attacker, defender)
	if(findtext(streak, KICK_COMBO))
		reset_streak()
		return Kick(attacker, defender)
	if(findtext(streak, FLYING_KICK_COMBO))
		reset_streak()
		return flyingKick(attacker, defender)
	if(findtext(streak, RESTRAIN_COMBO))
		reset_streak()
		return Restrain(attacker, defender)
	if(findtext(streak, PRESSURE_COMBO))
		reset_streak()
		return Pressure(attacker, defender)
	if(findtext(streak, CONSECUTIVE_COMBO))
		reset_streak()
		return Consecutive(attacker, defender)
	return FALSE

/datum/martial_art/mad_dog/proc/Slam(mob/living/attacker, mob/living/defender)
	if(defender.body_position != STANDING_UP)
		return FALSE

	attacker.do_attack_animation(defender)
	defender.visible_message(
		span_danger("[attacker] slams [defender] into the ground!"),
		span_userdanger("You're slammed into the ground by [attacker]!"),
		span_hear("You hear a sickening sound of flesh hitting flesh!"),
		null,
		attacker,
	)
	to_chat(attacker, span_danger("You slam [defender] into the ground!"))
	playsound(attacker, 'sound/items/weapons/slam.ogg', 50, TRUE, -1)
	defender.apply_damage(10, BRUTE)
	defender.Paralyze(12 SECONDS)
	log_combat(attacker, defender, "slammed (Mad Dog)")
	return TRUE

/datum/martial_art/mad_dog/proc/Kick(mob/living/attacker, mob/living/defender)
	if(defender.stat != CONSCIOUS)
		return FALSE

	attacker.do_attack_animation(defender)
	if(defender.body_position == LYING_DOWN && !defender.IsUnconscious() && defender.getStaminaLoss() >= 100)
		log_combat(attacker, defender, "knocked out (Head kick)(Mad Dog)")
		defender.visible_message(
			span_danger("[attacker] kicks [defender]'s head, knocking [defender.p_them()] out!"),
			span_userdanger("You're knocked unconscious by [attacker]!"),
			span_hear("You hear a sickening sound of flesh hitting flesh!"),
			null,
			attacker,
		)
		to_chat(attacker, span_danger("You kick [defender]'s head, knocking [defender.p_them()] out!"))
		playsound(attacker, 'sound/items/weapons/genhit1.ogg', 50, TRUE, -1)

		var/helmet_protection = defender.run_armor_check(BODY_ZONE_HEAD, MELEE)
		defender.apply_effect(20 SECONDS, EFFECT_KNOCKDOWN, helmet_protection)
		defender.apply_effect(10 SECONDS, EFFECT_UNCONSCIOUS, helmet_protection)
		defender.adjustOrganLoss(ORGAN_SLOT_BRAIN, 15, 150)

	else
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
		defender.throw_at(throw_target, 1, 14, attacker)
		defender.apply_damage(10, attacker.get_attack_type())
		if(defender.body_position == LYING_DOWN && !defender.IsUnconscious())
			defender.adjustStaminaLoss(45)
		log_combat(attacker, defender, "center kicked (Mad Dog)")

	return TRUE

/datum/martial_art/mad_dog/proc/flyingKick(mob/living/attacker, mob/living/defender)
	attacker.do_attack_animation(defender, ATTACK_EFFECT_KICK)
	defender.visible_message(
		span_warning("[attacker] jumps up and kicks [defender] right in the abdomen, sending them flying!"),
		span_userdanger("You are flying kicked in the abdomen by [attacker], sending you flying!"),
		span_hear("You hear the sickening sound of flesh hitting flesh!"),
		COMBAT_MESSAGE_RANGE,
		attacker,
	)
	playsound(attacker, 'sound/effects/hit_kick.ogg', 50, TRUE, -1)
	var/atom/throw_target = get_edge_target_turf(defender, attacker.dir)
	defender.throw_at(throw_target, 7, 4, attacker)
	defender.apply_damage(15, attacker.get_attack_type(), BODY_ZONE_CHEST, wound_bonus = CANT_WOUND)
	log_combat(attacker, defender, "flying kicked (Mad Dog)")
	return TRUE

/datum/martial_art/mad_dog/proc/Pressure(mob/living/attacker, mob/living/defender)
	attacker.do_attack_animation(defender)
	log_combat(attacker, defender, "pressured (Mad Dog)")
	defender.visible_message(
		span_danger("[attacker] punches [defender]'s neck!"),
		span_userdanger("Your neck is punched by [attacker]!"),
		span_hear("You hear a sickening sound of flesh hitting flesh!"),
		COMBAT_MESSAGE_RANGE,
		attacker,
	)
	to_chat(attacker, span_danger("You punch [defender]'s neck!"))
	defender.adjustStaminaLoss(60)
	playsound(attacker, 'sound/items/weapons/cqchit1.ogg', 50, TRUE, -1)
	return TRUE

/datum/martial_art/mad_dog/proc/Restrain(mob/living/attacker, mob/living/defender)
	if(restraining_mob?.resolve())
		return FALSE
	if(defender.stat != CONSCIOUS)
		return FALSE

	log_combat(attacker, defender, "restrained (Mad Dog)")
	defender.visible_message(
		span_warning("[attacker] locks [defender] into a restraining position!"),
		span_userdanger("You're locked into a restraining position by [attacker]!"),
		span_hear("You hear shuffling and a muffled groan!"),
		null,
		attacker,
	)
	to_chat(attacker, span_danger("You lock [defender] into a restraining position!"))
	defender.adjustStaminaLoss(20)
	defender.Stun(10 SECONDS)
	restraining_mob = WEAKREF(defender)
	addtimer(VARSET_CALLBACK(src, restraining_mob, null), 5 SECONDS, TIMER_UNIQUE)
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
	var/obj/item/held_item = defender.get_active_held_item()
	if(held_item && defender.temporarilyRemoveItemFromInventory(held_item))
		attacker.put_in_hands(held_item)
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

	var/old_grab_state = attacker.grab_state
	defender.grabbedby(attacker, TRUE)
	if(old_grab_state == GRAB_PASSIVE)
		defender.drop_all_held_items()
		attacker.setGrabState(GRAB_AGGRESSIVE) //Instant aggressive grab if on grab intent
		log_combat(attacker, defender, "grabbed", addition="aggressively")
		defender.visible_message(
			span_warning("[attacker] violently grabs [defender]!"),
			span_userdanger("You're grabbed violently by [attacker]!"),
			span_hear("You hear sounds of aggressive fondling!"),
			COMBAT_MESSAGE_RANGE,
			attacker,
		)
		to_chat(attacker, span_danger("You violently grab [defender]!"))
	return MARTIAL_ATTACK_SUCCESS

/datum/martial_art/mad_dog/harm_act(mob/living/attacker, mob/living/defender)
	if(attacker.grab_state == GRAB_KILL \
		&& attacker.zone_selected == BODY_ZONE_HEAD \
		&& attacker.pulling == defender \
		&& defender.stat != DEAD \
	)
		var/obj/item/bodypart/head = defender.get_bodypart(BODY_ZONE_HEAD)
		if(!isnull(head))
			playsound(defender, 'sound/effects/wounds/crack1.ogg', 100)
			defender.visible_message(
				span_danger("[attacker] snaps the neck of [defender]!"),
				span_userdanger("Your neck is snapped by [attacker]!"),
				span_hear("You hear a sickening snap!"),
				ignored_mobs = attacker
			)
			to_chat(attacker, span_danger("In a swift motion, you snap the neck of [defender]!"))
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
	var/picked_hit_type = pick("precision-punch", "pressure-kick")
	var/bonus_damage = 13
	if(defender.body_position == LYING_DOWN)
		bonus_damage += 5
		picked_hit_type = pick("kick", "stomp")
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
	if(prob(65) && (defender.stat == CONSCIOUS || !defender.IsParalyzed() || !restraining_mob?.resolve()))
		var/obj/item/disarmed_item = defender.get_active_held_item()
		if(disarmed_item && defender.temporarilyRemoveItemFromInventory(disarmed_item))
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

	defender.visible_message(
		span_danger("[attacker] fails to disarm [defender]!"), \
		span_userdanger("You're nearly disarmed by [attacker]!"),
		span_hear("You hear a swoosh!"),
		COMBAT_MESSAGE_RANGE,
		attacker,
	)
	to_chat(attacker, span_warning("You fail to disarm [defender]!"))
	playsound(defender, 'sound/items/weapons/punchmiss.ogg', 25, TRUE, -1)
	log_combat(attacker, defender, "failed to disarm (Mad Dog)")
	return MARTIAL_ATTACK_FAIL


/mob/living/proc/mad_dog_help()
	set name = "Remember Your Teachings"
	set desc = "Recall the core tenets of The Mad Dog's Style."
	set category = "The Mad Dog's Style"

	to_chat(usr, "<b><i>You remember the core tenets of The Mad Dog's Style...</i></b>\n\
	[span_notice("Slam")]: Grab Punch. Slam opponent into the ground, knocking them down.\n\
	[span_notice("Center Kick")]: Punch Punch. Knocks opponent away. Knocks out stunned opponents and does stamina damage.\n\
	[span_notice("Flying Kick")]: Punch Shove Punch. Sends opponents flying away into walls or other objects, like tables and people.\n\
	[span_notice("Restrain")]: Grab Grab. Locks opponents into a restraining position, allowing for deadly table slams or throwing them.\n\
	[span_notice("Neck Snap")]: Once you're choking someone, you can target their head and attack to snap their neck in one easy motion.\n\
	[span_notice("Pressure")]: Shove Grab. Decent stamina damage.\n\
	[span_notice("Combo Strike")]: Shove Shove Punch. Mainly offensive move, huge damage and decent stamina damage.\n\
	[span_notice("Deflective Palm")]: While on throw mode, you possess an 80% chance to block and counter attacks done to you, so long as you are able to fight.")

	to_chat(usr, "<b><i>Furthermore, you will not fall when in critical condition, will occasionally heal when extremely close to death, and can absorb stuns up to a limit, after which you must wait 20 seconds before absorbing more.</i></b>")

#undef SLAM_COMBO
#undef KICK_COMBO
#undef FLYING_KICK_COMBO
#undef RESTRAIN_COMBO
#undef PRESSURE_COMBO
#undef CONSECUTIVE_COMBO
