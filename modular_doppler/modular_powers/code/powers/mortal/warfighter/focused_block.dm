/datum/power/warfighter/focused_block
	name = "Focused Block"
	desc = "Using what you have on you, you gain a block chance that begins at 90% and decays to 0% over 4 seconds, as long as you are holding a bulky-sized item or an item with a block chance. \
	\nIf the item does not have a block chance, this bonus is halved.\
	\nThis block counts as a separate block chance from your normal block chance, is affected by armour piercing and does not damage your shield."
	security_record_text = "Subject can block attacks with extreme efficiency while wielding a shield or large object."
	security_threat = POWER_THREAT_MAJOR
	value = 4

	action_path = /datum/action/cooldown/power/warfighter/focused_block

/datum/action/cooldown/power/warfighter/focused_block
	name = "Focused Block"
	desc = "Gain a block chance that begins at 90% and decays to 0% over 4 seconds, as long as you are holding a bulky-sized item or an item with a block chance. Halved effect with non-blocking items."
	button_icon = 'icons/obj/weapons/shields.dmi'
	button_icon_state = "kite"
	cooldown_time = 100
	/// Starting block chance before item-specific adjustments.
	var/base_block_chance = 90
	/// Total time over which the block chance decays to 0%.
	var/decay_duration = 4 SECONDS

// Status effect handles most of the actual effects; we check for requirements here
/datum/action/cooldown/power/warfighter/focused_block/use_action(mob/living/user, atom/target)
	var/obj/item/active_item = user.get_active_held_item()
	var/obj/item/inactive_item = user.get_inactive_held_item()
	var/has_valid_item = FALSE
	var/has_blocking_item = FALSE

	if(active_item && (active_item.w_class >= WEIGHT_CLASS_BULKY || active_item.block_chance > 0))
		has_valid_item = TRUE
	if(inactive_item && (inactive_item.w_class >= WEIGHT_CLASS_BULKY || inactive_item.block_chance > 0))
		has_valid_item = TRUE
	if(active_item?.block_chance > 0 || inactive_item?.block_chance > 0)
		has_blocking_item = TRUE

	if(!has_valid_item)
		user.balloon_alert(user, "need bulky or blocking item")
		return FALSE

	var/applied_block_chance = has_blocking_item ? base_block_chance : base_block_chance / 2
	var/datum/status_effect/power/focused_block/applied = user.apply_status_effect(/datum/status_effect/power/focused_block, applied_block_chance, decay_duration)
	if(applied)
		applied.focused_block_action = src
	to_chat(user, span_warning("You focus on defending yourself!"))
	return !!applied

/// Displays the remaining Focused Block chance.
/atom/movable/screen/alert/status_effect/focused_block
	name = "Focused Block"
	desc = "Your chance to block an attack with Focused Block."
	icon = 'icons/obj/weapons/shields.dmi'
	icon_state = "kite"

/// Status effect that handles blocking
/datum/status_effect/power/focused_block
	id = "focused_block"
	duration = STATUS_EFFECT_PERMANENT
	tick_interval = 0.2 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect/focused_block
	status_type = STATUS_EFFECT_REPLACE
	/// Our linked action
	var/datum/action/cooldown/power/warfighter/focused_block/focused_block_action
	/// Block chance, passed in by the Focused Block action.
	var/base_block_chance
	/// Total time, in deciseconds, over which the chance decays to 0%.
	var/decay_duration
	/// Time, in seconds, spent decaying so far.
	var/decay_elapsed

/datum/status_effect/power/focused_block/on_apply()
	if(!owner)
		return FALSE
	var/image/flash_overlay = new('icons/effects/effects.dmi', owner, "shield-flash", dir = pick(GLOB.cardinals))
	owner.flick_overlay_view(flash_overlay, 30)
	RegisterSignal(owner, COMSIG_LIVING_CHECK_BLOCK, PROC_REF(check_block))
	return TRUE

/datum/status_effect/power/focused_block/on_creation(mob/living/new_owner, initial_block_chance, initial_decay_duration)
	if(isnum(initial_block_chance))
		base_block_chance = initial_block_chance
	if(isnum(initial_decay_duration))
		decay_duration = initial_decay_duration
	. = ..()
	if(.)
		update_block_chance_display()

/datum/status_effect/power/focused_block/on_remove()
	if(owner)
		UnregisterSignal(owner, COMSIG_LIVING_CHECK_BLOCK)

/// We use the COMSIG_LIVING_CHECK_BLOCK signal to check artifically for block.
/datum/status_effect/power/focused_block/proc/check_block(mob/living/blocking_user, atom/movable/hitby, damage, attack_text, attack_type, armour_penetration, damage_type)
	SIGNAL_HANDLER

	var/has_valid_item = FALSE
	for(var/obj/item/held_item in blocking_user.held_items)
		if(!held_item)
			continue
		if(held_item.w_class >= WEIGHT_CLASS_BULKY || held_item.block_chance > 0)
			has_valid_item = TRUE

	if(!has_valid_item)
		return NONE

	var/current_block_chance = get_current_block_chance()
	// Applies armour penetration to the block-chance.
	var/block_armour_penetration = get_block_armour_penetration()
	var/final_block_chance = current_block_chance - clamp((armour_penetration - block_armour_penetration) / 2, 0, 100)

	if(!prob(final_block_chance))
		return NONE
	block_effect(blocking_user, attack_text, final_block_chance)
	SEND_SIGNAL(blocking_user, COMSIG_POWERS_FOCUSED_BLOCK_SUCCESSFUL_BLOCK, src, final_block_chance)

	return SUCCESSFUL_BLOCK

/// Returns Focused Block's chance to block
/datum/status_effect/power/focused_block/proc/get_current_block_chance()
	var/current_base_block_chance = clamp(base_block_chance - (decay_elapsed SECONDS * base_block_chance / decay_duration), 0, 100)
	// Alt block from other sources
	var/highest_bonus_block_chance = 0
	var/list/block_chance_bonuses = list()
	SEND_SIGNAL(owner, COMSIG_POWERS_FOCUSED_BLOCK_BONUS_BLOCK, src, block_chance_bonuses)
	for(var/block_chance_bonus in block_chance_bonuses)
		if(isnum(block_chance_bonus))
			highest_bonus_block_chance = max(highest_bonus_block_chance, block_chance_bonus)
	// Returns the highest calculated
	return max(current_base_block_chance, highest_bonus_block_chance)

/// Returns the highest defensive armor penetration granted to Focused Block.
/datum/status_effect/power/focused_block/proc/get_block_armour_penetration()
	var/highest_block_armour_penetration = 0
	var/list/block_armour_penetration_bonuses = list()
	SEND_SIGNAL(owner, COMSIG_POWERS_FOCUSED_BLOCK_BONUS_ARMOUR_PENETRATION, src, block_armour_penetration_bonuses)
	for(var/block_armour_penetration_bonus in block_armour_penetration_bonuses)
		if(isnum(block_armour_penetration_bonus))
			highest_block_armour_penetration = max(highest_block_armour_penetration, block_armour_penetration_bonus)
	return clamp(highest_block_armour_penetration, 0, 100)

/// Applies block decay and updates the chance shown below the status icon.
/datum/status_effect/power/focused_block/tick(seconds_between_ticks)
	var/should_decay = !(SEND_SIGNAL(owner, COMSIG_POWERS_FOCUSED_BLOCK_SHOULD_DECAY, src) & COMPONENT_POWERS_FOCUSED_BLOCK_DONT_DECAY)
	if(should_decay)
		decay_elapsed += seconds_between_ticks
	update_block_chance_display()
	if(decay_elapsed SECONDS >= decay_duration)
		qdel(src)

/// Updates the status alert with the current block chance.
/datum/status_effect/power/focused_block/proc/update_block_chance_display()
	if(linked_alert)
		linked_alert.maptext = MAPTEXT_TINY_UNICODE("<span style='text-align:center; color:white'>[round(get_current_block_chance())]%</span>")

/// we have to mimmick the block effects cause they're not baked into COMSIG_LIVING_CHECK_BLOCK by default.
/datum/status_effect/power/focused_block/proc/block_effect(mob/living/blocking_user, attack_text, current_block_chance)
	blocking_user.visible_message(
		span_danger("[blocking_user] blocks [attack_text]!"),
		span_userdanger("You block [attack_text]!"),
	)
	var/owner_turf = get_turf(blocking_user)
	new /obj/effect/temp_visual/block(owner_turf, COLOR_YELLOW)
	playsound(blocking_user, 'sound/items/weapons/parry.ogg', BLOCK_SOUND_VOLUME, vary = TRUE, falloff_distance = MEDIUM_RANGE_SOUND_EXTRARANGE)
