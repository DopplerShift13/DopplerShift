/datum/power/cultivator_root/shadow_walker
	name = "Shadow Walker Alignment"
	desc = "You gain your Dantian's aura through dark rooms and environments. Activating it wraps you in an aura of shadow.\
	You are entirely unrecognizeable in this state and your punches do 10 extra toxins damage.\
	Passively, you have enhanced darkvision, and gain full on night vision while your alignment is activated.\
	You gain armor IV across your whole body. Has diminishing effects with your worn armor."
	action_path = /datum/action/cooldown/power/cultivator/alignment/shadow_walker

	value = 6

// Lets you see in the dark.
/datum/power/cultivator_root/shadow_walker/post_add()
	. = ..()
	ADD_TRAIT(power_holder, TRAIT_MINOR_NIGHT_VISION, REF(src))
	power_holder.update_sight()

/datum/power/cultivator_root/shadow_walker/remove()
	. = ..()
	REMOVE_TRAIT(power_holder, TRAIT_MINOR_NIGHT_VISION, REF(src))
	power_holder.update_sight()

/datum/action/cooldown/power/cultivator/alignment/shadow_walker
	name = "Shadow Walker Alignment"
	desc = "Activates your Shadow Walker Alignment aura, granting you immunity to slowdowns, increasing your defenses (if unarmored), and increasing your strength with unarmed attacks."
	button_icon = 'icons/mob/actions/actions_spells.dmi'
	button_icon_state = "void_magnet"


	alignment_outline_color = "#000000"
	alignment_damage_type = TOX

	// the spooky overlay unique to shadow walker
	var/mutable_appearance/echo_overlay

// Adds pressure immunity & cold immunity.
/datum/action/cooldown/power/cultivator/alignment/shadow_walker/enable_alignment(mob/living/carbon/user)
	. = ..()
	user.add_traits(list(TRAIT_UNKNOWN, TRAIT_TRUE_NIGHT_VISION), src)
	user.update_sight()

/datum/action/cooldown/power/cultivator/alignment/shadow_walker/disable_alignment(mob/living/carbon/user)
	. = ..()
	user.remove_traits(list(TRAIT_UNKNOWN, TRAIT_TRUE_NIGHT_VISION), src)
	user.update_sight()
	user.cut_overlay(echo_overlay)

// We override the normal fx activation because this looks cooler.
/datum/action/cooldown/power/cultivator/alignment/shadow_walker/activation_fx(mob/living/carbon/user, atom/target)
	// Use the same matrix as echolocation
	var/static/list/black_white_matrix = list(
		85, 85, 85, 0,
		85, 85, 85, 0,
		85, 85, 85, 0,
		0, 0, 0, 1,
		-254, -254, -254, 0
	)
	echo_overlay = new /mutable_appearance()
	echo_overlay.appearance = user
	echo_overlay.color = black_white_matrix
	echo_overlay.filters += outline_filter(size = 1, color = COLOR_WHITE)

	echo_overlay.layer = user.layer + 0.1
	user.add_overlay(echo_overlay)

	// adds overlay
	if(!alignment_overlay)
		alignment_overlay = mutable_appearance(alignment_overlay_icon, alignment_overlay_state, alignment_overlay_layer)
	alignment_overlay.color = alignment_outline_color
	user.add_overlay(alignment_overlay)

	// white outline but slightly differently
	user.remove_filter(filter_id)
	user.add_filter(filter_id, 2, outline_filter(size = alignment_outline_size, color = "#ffffff"))
	var/filter = user.get_filter(filter_id)
	if(filter)
		animate(filter, alpha = 110, time = 1.5 SECONDS, loop = -1)
		animate(alpha = 40, time = 2.5 SECONDS)
