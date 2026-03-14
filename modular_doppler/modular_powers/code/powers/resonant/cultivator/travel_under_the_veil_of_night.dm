/*
	Teleports you from one dark turf to the other.
	Note: I am disgusted at the sheer amount of ifs but uhh, this is the best I could think of.
*/


/datum/power/cultivator/travel_under_the_veil_of_night
	name = "Travel Under the Veil of Night"
	desc = "Whilst your alignment is active, you can spend 2 seconds channeling in a space of darkness to teleport to another space of darkness within line of sight. Has a Dantian cost; no cooldown."
	security_record_text = "Subject can teleport in darkness while in their heightened state."
	security_threat = POWER_THREAT_MAJOR
	value = 5
	required_powers = list(/datum/power/cultivator_root/shadow_walker)
	action_path = /datum/action/cooldown/power/cultivator/travel_under_the_veil_of_night

/datum/action/cooldown/power/cultivator/travel_under_the_veil_of_night
	name = "Travel Under the Veil of Night"
	desc = "Whilst your alignment is active, you can spend 2 seconds channeling in a space of darkness to teleport to another space of darkness within line of sight. Has a Dantian cost; no cooldown."
	button_icon = 'icons/effects/effects.dmi'
	button_icon_state = "blank"

	click_to_activate = TRUE
	unset_after_click = TRUE
	cost = 50

	// Cached alignment action for gating effects.
	var/datum/action/cooldown/power/cultivator/alignment/shadow_walker/shadow_walker_alignment

/datum/action/cooldown/power/cultivator/travel_under_the_veil_of_night/use_action(mob/living/user, atom/target)
	if(!target)
		return FALSE
	// no teleporting out of where-ever-the-nowhere you are
	var/turf/user_turf = get_turf(user)
	if(!user_turf)
		return FALSE
	// alignment required + darkness
	if(!is_shadow_walker_alignment_active(user) || !is_turf_in_darkness(user_turf))
		user.balloon_alert(user, "alignment + darkness required!")
		return FALSE
	// LOS requirement
	if(!(target in view(user.client.view, user)))
		user.balloon_alert(user, "out of view!")
		return FALSE
	var/turf/target_turf = get_turf(target)
	// is it open & unblocked?
	if(!is_valid_destination(target_turf))
		user.balloon_alert(user, "invalid destination!")
		return FALSE

	// Do after.
	if(!do_after(user, 2 SECONDS, target = user))
		return FALSE

	// Revalidate after channeling.
	// recheck if we still have valid turfs (something may happen to them???)
	if(!user_turf || !target_turf)
		return FALSE
	// alignment required + darkness
	if(!is_shadow_walker_alignment_active(user) || !is_turf_in_darkness(user_turf))
		user.balloon_alert(user, "alignment + darkness required!")
		return FALSE
	// LOS requirement
	if(!(target in view(user.client.view, user)))
		user.balloon_alert(user, "out of view!")
		return FALSE
	// is it open & unblocked?
	if(!is_valid_destination(target_turf))
		user.balloon_alert(user, "invalid destination!")
		return FALSE

	// Okay so after that giant check of requirements now we actually try to teleport the person.
	if(!do_teleport(user, target_turf, no_effects = TRUE))
		return FALSE
	playsound(target_turf, 'sound/effects/nightmare_poof.ogg', 60, TRUE, SHORT_RANGE_SOUND_EXTRARANGE)
	playsound(user_turf, 'sound/effects/nightmare_reappear.ogg', 60, TRUE, SHORT_RANGE_SOUND_EXTRARANGE)
	// After image
	new /obj/effect/temp_visual/blank_echo(user_turf)
	return TRUE

// Basically is the turf open/blocked?
/datum/action/cooldown/power/cultivator/travel_under_the_veil_of_night/proc/is_valid_destination(turf/target_turf)
	if(!target_turf || !isopenturf(target_turf))
		return FALSE
	if(target_turf.is_blocked_turf(exclude_mobs = TRUE))
		return FALSE
	return is_turf_in_darkness(target_turf)

// IS IT DARK?!
/datum/action/cooldown/power/cultivator/travel_under_the_veil_of_night/proc/is_turf_in_darkness(turf/target_turf)
	if(!target_turf)
		return FALSE
	return target_turf.get_lumcount() <= LIGHTING_TILE_IS_DARK

// ARE WE GOING SUPER SAIYAN?!
/datum/action/cooldown/power/cultivator/travel_under_the_veil_of_night/proc/is_shadow_walker_alignment_active(mob/living/user)
	if(!shadow_walker_alignment || QDELETED(shadow_walker_alignment))
		for(var/datum/action/cooldown/power/cultivator/alignment/shadow_walker/alignment_action in user.actions)
			shadow_walker_alignment = alignment_action
			break
	if(!shadow_walker_alignment)
		return FALSE
	return shadow_walker_alignment.active

/obj/effect/temp_visual/blank_echo
	icon = 'icons/effects/effects.dmi'
	icon_state = "blank"
	duration = 2 SECONDS
	randomdir = FALSE

/obj/effect/temp_visual/blank_echo/Initialize(mapload)
	. = ..()
	animate(src, alpha = 0, time = duration)
