/datum/power/warfighter/focused_block
	name = "Focused Block"
	desc = "Using what you have on you, you raise your block chance by 50 for 1.5 seconds, as long as you are holding a bulky-sized item or an item with a block chance. \
	This stacks on-top of any existing block you may have, guaranteeing blocks with most shields. Has a short cooldown."
	security_record_text = "Subject can block attacks with extreme efficiency while wielding a shield or large object."
	security_threat = POWER_THREAT_MAJOR
	value = 6

	action_path = /datum/action/cooldown/power/warfighter/focused_block
	required_powers = list(/datum/power/warfighter/quick_draw)

/datum/action/cooldown/power/warfighter/focused_block
	name = "Focused Block"
	desc = "You raise your block chance by 50 for 1.5 seconds, as long as you are holding a bulky-sized item or an item with a block chance. This stacks on-top of any existing block you may have."
	button_icon = 'icons/obj/weapons/shields.dmi'
	button_icon_state = "kite"
	cooldown_time = 120

// Status effect handles most of the actual effects; we check for requirements here
/datum/action/cooldown/power/warfighter/focused_block/use_action(mob/living/user, atom/target)
	var/obj/item/active_item = user.get_active_held_item()
	var/obj/item/inactive_item = user.get_inactive_held_item()
	var/has_valid_item = FALSE

	if(active_item && (active_item.w_class >= WEIGHT_CLASS_BULKY || active_item.block_chance > 0))
		has_valid_item = TRUE
	else if(inactive_item && (inactive_item.w_class >= WEIGHT_CLASS_BULKY || inactive_item.block_chance > 0))
		has_valid_item = TRUE

	if(!has_valid_item)
		user.balloon_alert(user, "need bulky or blocking item")
		return FALSE

	// apply status effect
	var/datum/status_effect/power/focused_block/applied = user.apply_status_effect(/datum/status_effect/power/focused_block)
	return !!applied

// 1.5 seconds of hieghtened block
/datum/status_effect/power/focused_block
	id = "focused_block"
	duration = 1.5 SECONDS
	tick_interval = STATUS_EFFECT_NO_TICK
	alert_type = null
	var/block_bonus = 50

/datum/status_effect/power/focused_block/on_apply()
	if(!owner)
		return FALSE
	var/image/flash_overlay = new('icons/effects/effects.dmi', owner, "shield-flash", dir = pick(GLOB.cardinals))
	owner.flick_overlay_view(flash_overlay, 30)
	RegisterSignal(owner, COMSIG_LIVING_CHECK_BLOCK, PROC_REF(check_block))
	return TRUE

/datum/status_effect/power/focused_block/on_remove()
	if(owner)
		UnregisterSignal(owner, COMSIG_LIVING_CHECK_BLOCK)

/// We use the COMSIG_LIVING_CHECK_BLOCK signal to check artifically for block.
/datum/status_effect/power/focused_block/proc/check_block(mob/living/blocking_user, atom/movable/hitby, damage, attack_text, attack_type, armour_penetration, damage_type)
	SIGNAL_HANDLER

	var/has_valid_item = FALSE
	var/best_block = 0
	for(var/obj/item/held_item in blocking_user.held_items)
		if(!held_item)
			continue
		if(held_item.w_class >= WEIGHT_CLASS_BULKY || held_item.block_chance > 0)
			has_valid_item = TRUE
			if(held_item.block_chance > best_block)
				best_block = held_item.block_chance

	if(!has_valid_item)
		return NONE

	// guaranteed block chance
	best_block = max(best_block, 0)
	var/target_block = min(100, best_block + block_bonus)
	if(target_block >= 100)
		block_effect(blocking_user, attack_text)
		return SUCCESSFUL_BLOCK

	// random chance for block
	var/bonus_chance = 100 - ((100 - target_block) * 100 / (100 - best_block))
	bonus_chance = clamp(bonus_chance, 0, 100)
	if(!prob(bonus_chance))
		return NONE
	block_effect(blocking_user, attack_text)
	return SUCCESSFUL_BLOCK

/// we have to mimmick the block effects cause they're not baked into COMSIG_LIVING_CHECK_BLOCK by default.
/datum/status_effect/power/focused_block/proc/block_effect(mob/living/blocking_user, attack_text)
	blocking_user.visible_message(
		span_danger("[blocking_user] blocks [attack_text]!"),
		span_userdanger("You block [attack_text]!"),
	)
	var/owner_turf = get_turf(blocking_user)
	new /obj/effect/temp_visual/block(owner_turf, COLOR_YELLOW)
	playsound(blocking_user, 'sound/items/weapons/parry.ogg', BLOCK_SOUND_VOLUME, vary = TRUE)
