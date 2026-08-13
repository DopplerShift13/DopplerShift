/*
	Lets you do the Tchotchke Style. A martial art stylized a bit after Kaza Ruk, with the goal of being stronger against powers-users and rewarding smart play.
	- Dazing Strike, a punch that always hits the head, deals a bit of extra oxygen damage that also puts everything with a cooldown on cooldown for 2.5s, and adding 2.5s to any active cooldowns.
	- Gripbreaker, a punch that always hits limbs, that makes the next shove within 3s on the target guarantee an item drop.
	- Dishevel, a shove that pushes back +1 space. Great for wall-stun-fu.
	All of these have separate 5s cooldowns. This ironically make them susceptible to other Tchotchke Styles.
*/
/datum/power/warfighter/tchotchke_style
	name = "Tchotchke Gutter Fighting"
	desc = "Grants you the Tchotchke Gutter Fighting martial art. Having its root in the mage planet of Tchotchke, it was used by the various less-gifted individuals to put themselves on even ground against mages, \
	specialized in targeting various key-weaknesses to their power. It is surprisingly useful even against normal combatants, with its ability to disrupt an enemy's focus by putting their actions on cooldown,\
	being able to disarm foes with a measure of set-up, and perform more powerful shoves."
	security_record_text = "Subject can wield the Tchotchke Gutter Fighting martial art in unarmed combat."
	security_threat = POWER_THREAT_MAJOR
	value = 8
	required_powers = list(/datum/power/warfighter/martial_artist)

	menu_icon = 'icons/obj/clothing/gloves.dmi'
	menu_icon_state = "wizard"

	/// Uniquely, martial arts components are stored in the minds. Most powers are stored per mob, so this is a bit of an odd case.
	var/datum/component/mindbound_martial_arts/martial_art_component

/datum/power/warfighter/tchotchke_style/add()
	if(!power_holder?.mind)
		return
	martial_art_component = power_holder.mind.AddComponent(/datum/component/mindbound_martial_arts, /datum/martial_art/tchotchke_style)

/datum/power/warfighter/tchotchke_style/remove()
	if(martial_art_component)
		qdel(martial_art_component)
		martial_art_component = null

/*
	The Martial Art in question
*/
/datum/martial_art/tchotchke_style
	name = "Tchotchke Style"
	id = MARTIALART_TCHOTCHKE_STYLE
	VAR_PRIVATE/datum/action/cooldown/power/warfighter/dazing_strike/dazing_strike
	VAR_PRIVATE/datum/action/cooldown/power/warfighter/gripbreaker/gripbreaker
	VAR_PRIVATE/datum/action/cooldown/power/warfighter/dishevel/dishevel
	/// Base damage done by martial arts attacks
	var/base_damage = 5
	/// Chambered harm attack. Shared by Dazing Strike and Gripbreaker.
	var/chambered_harm_attack = ""
	/// Chambered disarm attack. Separate so Dishevel can coexist with harm chambers.
	var/chambered_disarm_attack = ""
	/// Cached arm struck by Gripbreaker so damage riders hit the same limb.
	var/obj/item/bodypart/gripbreaker_hit_limb

/datum/martial_art/tchotchke_style/New()
	. = ..()
	dazing_strike = new /datum/action/cooldown/power/warfighter/dazing_strike(src)
	gripbreaker = new /datum/action/cooldown/power/warfighter/gripbreaker(src)
	dishevel = new /datum/action/cooldown/power/warfighter/dishevel(src)

/datum/martial_art/tchotchke_style/Destroy()
	dazing_strike = null
	gripbreaker = null
	dishevel = null
	gripbreaker_hit_limb = null
	return ..()

/datum/martial_art/tchotchke_style/activate_style(mob/living/new_holder)
	. = ..()
	to_chat(new_holder, span_userdanger("You know the arts of the [name]!"))
	to_chat(new_holder, span_danger("Choose a strike to chamber your next attack, or ready Dishevel for your next shove."))
	dazing_strike.Grant(new_holder)
	gripbreaker.Grant(new_holder)
	dishevel.Grant(new_holder)

/datum/martial_art/tchotchke_style/deactivate_style(mob/living/remove_from)
	to_chat(remove_from, span_userdanger("You suddenly forget the arts of [name]..."))
	chambered_harm_attack = ""
	chambered_disarm_attack = ""
	gripbreaker_hit_limb = null
	dazing_strike?.Remove(remove_from)
	gripbreaker?.Remove(remove_from)
	dishevel?.Remove(remove_from)
	return ..()

/// Chambers your next left-click attack to be a specific attack
/datum/martial_art/tchotchke_style/proc/chamber_harm_attack(mob/living/user, attack_id, attack_name)
	if(chambered_harm_attack == attack_id)
		clear_harm_chamber(user)
		return

	chambered_harm_attack = attack_id
	user.visible_message(span_danger("[user] readies [attack_name]!"), "<b><i>Your next punch will be [attack_name].</i></b>")

/// Chambers your next right-click shove to be a specific attack
/datum/martial_art/tchotchke_style/proc/chamber_disarm_attack(mob/living/user, attack_id, attack_name)
	if(chambered_disarm_attack == attack_id)
		clear_disarm_chamber(user)
		return

	chambered_disarm_attack = attack_id
	user.visible_message(span_danger("[user] readies [attack_name]!"), "<b><i>Your next shove will be [attack_name].</i></b>")

/// Removes the current loaded left-click attack
/datum/martial_art/tchotchke_style/proc/clear_harm_chamber(mob/living/user)
	chambered_harm_attack = ""
	gripbreaker_hit_limb = null
	user.visible_message(span_danger("[user] relaxes [user.p_their()] striking stance."), "<b><i>Your readied strike is cleared.</i></b>")

/// Removes the currnet loaded right-click attack
/datum/martial_art/tchotchke_style/proc/clear_disarm_chamber(mob/living/user)
	chambered_disarm_attack = ""
	user.visible_message(span_danger("[user] relaxes [user.p_their()] shoving stance."), "<b><i>Your readied shove is cleared.</i></b>")

/// We override the unarmed hit signal so we can actually pass what limb our martial art is hitting.
/datum/martial_art/tchotchke_style/send_unarmed_hit_signal(mob/living/attacker, mob/living/defender)
	if(!attacker || !defender)
		return

	/// Forces what limb is being given
	var/obj/item/bodypart/affecting
	switch(chambered_harm_attack)
		if("dazing_strike")
			affecting = defender.get_bodypart(BODY_ZONE_HEAD)
		if("gripbreaker")
			affecting = gripbreaker_hit_limb
			if(!affecting)
				affecting = defender.get_bodypart(BODY_ZONE_R_ARM) || defender.get_bodypart(BODY_ZONE_L_ARM)

	if(!affecting)
		return ..()

	var/armor_block = defender.run_armor_check(affecting, MELEE)
	var/obj/item/bodypart/attacking_limb = get_attacking_limb(attacker, defender)
	if(!attacking_limb && ishuman(attacker))
		var/mob/living/carbon/human/human_attacker = attacker
		attacking_limb = human_attacker.get_active_hand()

	var/limb_sharpness = attacking_limb?.unarmed_sharpness
	SEND_SIGNAL(attacker, COMSIG_HUMAN_UNARMED_HIT, defender, affecting, 0, armor_block, limb_sharpness)
	chambered_harm_attack = ""
	gripbreaker_hit_limb = null

/// Checks what our next left-click attack will be, if any.
/datum/martial_art/tchotchke_style/proc/check_harm_chamber(mob/living/attacker, mob/living/defender)
	var/attack_selected = FALSE
	var/attack_result = MARTIAL_ATTACK_INVALID
	switch(chambered_harm_attack)
		if("dazing_strike")
			attack_selected = TRUE
			attack_result = do_dazing_strike(attacker, defender)
		if("gripbreaker")
			attack_selected = TRUE
			attack_result = do_gripbreaker(attacker, defender)
	if(attack_selected && attack_result != MARTIAL_ATTACK_SUCCESS)
		chambered_harm_attack = ""
		gripbreaker_hit_limb = null
	return attack_result

/// Checks what our next right-click attack will be, if any.
/datum/martial_art/tchotchke_style/proc/check_disarm_chamber(mob/living/attacker, mob/living/defender)
	switch(chambered_disarm_attack)
		if("dishevel")
			chambered_disarm_attack = ""
			return do_dishevel(attacker, defender)
	return FALSE

/// Performs the effects of dazing strike.
/datum/martial_art/tchotchke_style/proc/do_dazing_strike(mob/living/attacker, mob/living/defender)
	if(HAS_TRAIT(attacker, TRAIT_PACIFISM))
		return MARTIAL_ATTACK_INVALID

	attacker.do_attack_animation(defender)
	defender.visible_message(
		span_warning("[attacker] slams [defender] in the head with a dazing strike!"),
		span_userdanger("[attacker] slams you in the head with a dazing strike!"),
		span_hear("You hear a sharp, cracking impact!"),
		COMBAT_MESSAGE_RANGE,
		attacker,
	)
	to_chat(attacker, span_danger("You strike [defender]'s head and rattle [defender.p_their()] focus!"))
	playsound(attacker, 'sound/effects/hit_punch.ogg', 50, TRUE, -1)

	// Checks defenses and applies both oxy and brute damage based on armor.
	var/head_armor = defender.run_armor_check(def_zone = BODY_ZONE_HEAD, attack_flag = MELEE, silent = TRUE)
	defender.apply_damage(base_damage, BRUTE, BODY_ZONE_HEAD, head_armor)
	defender.apply_damage(10, OXY, BODY_ZONE_HEAD, head_armor)

	// Iterates through every action/cooldown on the mob and checks if it has a cooldown and if so, whether its on cooldown and should be made longer, or put on cooldown.
	for(var/datum/action/cooldown/cooldown_action in defender.actions)
		if(!cooldown_action.cooldown_time)
			continue
		if(cooldown_action.next_use_time > world.time)
			cooldown_action.next_use_time += 25
			cooldown_action.build_all_button_icons(UPDATE_BUTTON_STATUS)
			START_PROCESSING(SSfastprocess, cooldown_action)
			continue
		cooldown_action.StartCooldownSelf(25)

	defender.flash_act(visual = TRUE, length = 0.25 SECONDS)
	dazing_strike.StartCooldown()
	log_combat(attacker, defender, "dazing struck")
	return MARTIAL_ATTACK_SUCCESS

/// Performs the effects of gripbreaker.
/datum/martial_art/tchotchke_style/proc/do_gripbreaker(mob/living/attacker, mob/living/defender)
	attacker.do_attack_animation(defender)
	defender.visible_message(
		span_warning("[attacker] hammers [defender]'s grip with a precise strike!"),
		span_userdanger("[attacker] hammers your grip with a precise strike!"),
		span_hear("You hear a jarring smack!"),
		COMBAT_MESSAGE_RANGE,
		attacker,
	)
	to_chat(attacker, span_danger("You compromise [defender]'s grip, setting up the next shove!"))
	playsound(attacker, 'sound/effects/hit_punch.ogg', 50, TRUE, -1)

	var/obj/item/bodypart/target_arm = defender.get_active_hand()
	if(!target_arm)
		target_arm = defender.get_bodypart(BODY_ZONE_R_ARM) || defender.get_bodypart(BODY_ZONE_L_ARM)
	gripbreaker_hit_limb = target_arm
	if(target_arm)
		var/arm_armor = defender.run_armor_check(def_zone = target_arm, attack_flag = MELEE, silent = TRUE)
		defender.apply_damage(base_damage, BRUTE, target_arm, arm_armor)

	var/datum/status_effect/power/gripbreaker_mark/applied_effect = defender.apply_status_effect(/datum/status_effect/power/gripbreaker_mark)
	if(!applied_effect)
		gripbreaker_hit_limb = null
		return MARTIAL_ATTACK_FAIL

	gripbreaker.StartCooldown()
	log_combat(attacker, defender, "gripbreaker struck")
	return MARTIAL_ATTACK_SUCCESS

/// Performs the effects of dishevel
/datum/martial_art/tchotchke_style/proc/do_dishevel(mob/living/attacker, mob/living/defender)
	if(!attacker.can_disarm(defender))
		return MARTIAL_ATTACK_INVALID

	var/datum/status_effect/power/dishevel_shove/dishevel_effect = defender.apply_status_effect(/datum/status_effect/power/dishevel_shove)
	attacker.disarm(defender)
	if(dishevel_effect && !QDELETED(dishevel_effect))
		qdel(dishevel_effect)
	dishevel.StartCooldown()
	return MARTIAL_ATTACK_SUCCESS

/// Override on harm action to handle chambered attacks
/datum/martial_art/tchotchke_style/harm_act(mob/living/attacker, mob/living/defender)
	if(defender.check_block(attacker, 0, attacker.name, UNARMED_ATTACK))
		return MARTIAL_ATTACK_FAIL
	if(check_harm_chamber(attacker, defender))
		return MARTIAL_ATTACK_SUCCESS
	return MARTIAL_ATTACK_INVALID

/// Override on disarm action to handle chambered attacks
/datum/martial_art/tchotchke_style/disarm_act(mob/living/attacker, mob/living/defender)
	if(defender.check_block(attacker, 0, attacker.name, UNARMED_ATTACK))
		return MARTIAL_ATTACK_FAIL
	if(check_disarm_chamber(attacker, defender))
		return MARTIAL_ATTACK_SUCCESS
	return MARTIAL_ATTACK_INVALID

/*
	Bit of clarity. We are using powers actions here just cause it has more parity + is actually more fleshed out than regular cooldown actions.
*/
/datum/action/cooldown/power/warfighter/dazing_strike
	name = "Dazing Strike"
	desc = "Strike the target's head, breaking their focus. This deals a small amount of extra choke damage and causes a short cooldown on all their actions that have a cooldown; as well as any existing cooldowns will last a little longer."
	button_icon = 'icons/mob/actions/actions_cult.dmi'
	button_icon_state = "horror"
	check_flags = AB_CHECK_INCAPACITATED|AB_CHECK_HANDS_BLOCKED|AB_CHECK_CONSCIOUS

	cooldown_time = 5 SECONDS

/datum/action/cooldown/power/warfighter/dazing_strike/use_action(mob/living/user, atom/target)
	var/datum/martial_art/tchotchke_style/source = src.target
	if(!istype(source))
		return FALSE
	source.chamber_harm_attack(user, "dazing_strike", name)
	return FALSE

/datum/action/cooldown/power/warfighter/gripbreaker
	name = "Gripbreaker"
	desc = "Strike the target's hands. The next shove on the target within 3 seconds will guarantee the target drops their currently held active item (or off-hand, if there's no item in the current active hand)."
	button_icon = 'icons/mob/actions/actions_cult.dmi'
	button_icon_state = "bloodspear"
	check_flags = AB_CHECK_INCAPACITATED|AB_CHECK_HANDS_BLOCKED|AB_CHECK_CONSCIOUS

	cooldown_time = 5 SECONDS

/datum/action/cooldown/power/warfighter/gripbreaker/use_action(mob/living/user, atom/target)
	var/datum/martial_art/tchotchke_style/source = src.target
	if(!istype(source))
		return FALSE
	source.chamber_harm_attack(user, "gripbreaker", name)
	return FALSE

/datum/action/cooldown/power/warfighter/dishevel
	name = "Dishevel"
	desc = "A practiced, opportune kick that knocks a target further away. Enhances your next shove to knock the target an extra space further."
	button_icon = 'icons/mob/actions/actions_items.dmi'
	button_icon_state = "wheelys"
	check_flags = AB_CHECK_INCAPACITATED|AB_CHECK_HANDS_BLOCKED|AB_CHECK_CONSCIOUS

	cooldown_time = 5 SECONDS

/datum/action/cooldown/power/warfighter/dishevel/use_action(mob/living/user, atom/target)
	var/datum/martial_art/tchotchke_style/source = src.target
	if(!istype(source))
		return FALSE
	source.chamber_disarm_attack(user, "dishevel", name)
	return FALSE

/*
	Status effect applied by gripbreaker
*/
/datum/status_effect/power/gripbreaker_mark
	id = "gripbreaker_mark"
	duration = 3 SECONDS
	show_duration = TRUE
	status_type = STATUS_EFFECT_REFRESH
	tick_interval = STATUS_EFFECT_NO_TICK
	alert_type = /atom/movable/screen/alert/status_effect/gripbreaker_mark

/datum/status_effect/power/gripbreaker_mark/on_apply()
	if(!owner)
		return FALSE
	RegisterSignal(owner, COMSIG_LIVING_SHOVE_SUCCESS, PROC_REF(on_shove_success))
	return TRUE

/datum/status_effect/power/gripbreaker_mark/on_remove()
	if(owner)
		UnregisterSignal(owner, COMSIG_LIVING_SHOVE_SUCCESS)

/// Signal handler for shoving, which forces the target to drop their item.
/datum/status_effect/power/gripbreaker_mark/proc/on_shove_success(mob/living/source, mob/living/shover, shove_flags, obj/item/weapon)
	SIGNAL_HANDLER

	var/obj/item/held_item = owner.get_active_held_item()
	if(!held_item)
		held_item = owner.get_inactive_held_item()

	if(held_item && owner.dropItemToGround(held_item))
		owner.visible_message(
			span_danger("[owner] loses [owner.p_their()] grip on [held_item]!"),
			span_userdanger("You lose your grip on [held_item]!"),
			null,
			COMBAT_MESSAGE_RANGE,
		)
		to_chat(shover, span_danger("[owner] drops [held_item]!"))

	qdel(src)

/*
	Status effect applied by dishevel
*/
/datum/status_effect/power/dishevel_shove
	id = "dishevel_shove"
	duration = 1 SECONDS
	tick_interval = STATUS_EFFECT_NO_TICK
	alert_type = null

/datum/status_effect/power/dishevel_shove/on_apply()
	if(!owner)
		return FALSE
	RegisterSignal(owner, COMSIG_LIVING_SHOVE_SUCCESS, PROC_REF(on_shove_success))
	return TRUE

/datum/status_effect/power/dishevel_shove/on_remove()
	if(owner)
		UnregisterSignal(owner, COMSIG_LIVING_SHOVE_SUCCESS)

/datum/status_effect/power/dishevel_shove/proc/on_shove_success(mob/living/source, mob/living/shover, shove_flags, obj/item/weapon)
	SIGNAL_HANDLER

	if(shove_flags & SHOVE_BLOCKED)
		qdel(src)
		return

	if(!ismovable(owner))
		qdel(src)
		return

	var/throw_dir = get_dir(shover, owner)
	if(!throw_dir)
		qdel(src)
		return

	var/atom/throw_target = get_edge_target_turf(owner, throw_dir)
	owner.safe_throw_at(throw_target, 1, 1, shover, gentle = FALSE)
	qdel(src)

/atom/movable/screen/alert/status_effect/gripbreaker_mark
	name = "Broken Grip"
	desc = "If you get shoved, you will drop your current active item!"
	icon = 'icons/mob/actions/actions_cult.dmi'
	icon_state = "bloodspear"
