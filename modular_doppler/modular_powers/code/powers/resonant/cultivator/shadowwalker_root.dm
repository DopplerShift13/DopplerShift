/datum/power/cultivator_root/shadow_walker
	name = "Shadow Walker Alignment"
	desc = "You gain Energy through Aura by being in dark rooms and environments. Activating it wraps you in an aura of shadow.\
	\nYou are entirely unrecognizeable in this state and your punches do extra brute damage.\
	\nPassively, you have enhanced darkvision, and gain full on night vision while your alignment is activated.\
	\nYou gain armor IV across your whole body. Has diminishing effects with your worn armor."
	security_record_text = "Subject can enter a heightened state by observing darkness, granting them resistance to damage, deadlier punches, the abiliy to become unrecognizeable as a dark silhouette and the ability to see perfectly in the dark."
	security_threat = POWER_THREAT_MAJOR
	action_path = /datum/action/cooldown/power/cultivator/alignment/shadow_walker
	value = 5

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
	alignment_overlay_state = "curse"

	/// the spooky overlay unique to shadow walker
	var/mutable_appearance/echo_overlay
	/// global name/identity masking
	var/datum/shadowwalker_identity/shadowwalker_identity

// Adds pressure immunity & cold immunity.
/datum/action/cooldown/power/cultivator/alignment/shadow_walker/enable_alignment(mob/living/carbon/user)
	. = ..()
	ADD_TRAIT(user, TRAIT_TRUE_NIGHT_VISION, src)
	user.update_sight()
	RegisterSignal(user, COMSIG_MOB_UPDATE_HELD_ITEMS, PROC_REF(on_held_items_updated))
	RegisterSignal(user, COMSIG_LIVING_POST_UPDATE_TRANSFORM, PROC_REF(on_transform_updated))
	if(!shadowwalker_identity)
		shadowwalker_identity = new(user)
	refresh_echo_overlay(user)
	//extra spooky 4 clown
	if(is_clown_job(user.mind?.assigned_role))
		playsound(user, 'sound/misc/scary_horn.ogg', 60, TRUE)

/datum/action/cooldown/power/cultivator/alignment/shadow_walker/disable_alignment(mob/living/carbon/user)
	. = ..()
	REMOVE_TRAIT(user, TRAIT_TRUE_NIGHT_VISION, src)
	user.update_sight()
	UnregisterSignal(user, COMSIG_MOB_UPDATE_HELD_ITEMS)
	UnregisterSignal(user, COMSIG_LIVING_POST_UPDATE_TRANSFORM)
	QDEL_NULL(shadowwalker_identity)
	user.cut_overlay(echo_overlay)

/datum/action/cooldown/power/cultivator/alignment/shadow_walker/aura_farm()
	var/total = 0
	var/mob/living/owner_mob = owner
	if(!owner_mob)
		return total

	// For reference: dark means lum <=0.2, dim is lum <=0.5 and everything above that is called bright.
	var/dim_space_value = CULTIVATOR_AURA_FARM_TRIVIAL * 0.2 // if there's dim light
	var/darkness_space_value = CULTIVATOR_AURA_FARM_TRIVIAL // darkness itself
	var/stood_in_darkness = CULTIVATOR_AURA_FARM_MODERATE // if we are stood in the dark
	var/fully_dark_bonus = CULTIVATOR_AURA_FARM_MODERATE // only seeing dim and dark
	var/spacious_fully_dark_bonus = CULTIVATOR_AURA_FARM_MODERATE // only seeing dim and dark + is spacious (30)

	var/dim_threshold = 0.5
	var/viewable_turfs = 0
	var/any_bright = FALSE

	// Gets the dim and darkness of every space
	for(var/turf/T in view(owner_mob))
		if(!istype(T, /turf/open)) // no walls
			continue
		if(IS_OPAQUE_TURF(T)) // no non-opaque stuff (shutters, blackened windows, etc) that still counts as open
			continue
		viewable_turfs++
		var/lum = T.get_lumcount()
		if(lum <= LIGHTING_TILE_IS_DARK)
			total += darkness_space_value
		else if(lum <= dim_threshold)
			total += dim_space_value
		else
			any_bright = TRUE

	// Are we stood in darkness? Or are we stuffed away somewhere that the light probably doesn't see us?
	var/turf/owner_turf = get_turf(owner_mob)
	if(!isturf(owner_mob.loc) || (owner_turf && owner_turf.get_lumcount() <= dim_threshold))
		total += stood_in_darkness

	// Are there any bright tiles?
	if(!any_bright)
		total += fully_dark_bonus
		if(viewable_turfs >= 30)
			total += spacious_fully_dark_bonus

	return total

// We override the normal fx activation because this looks cooler.
/datum/action/cooldown/power/cultivator/alignment/shadow_walker/activation_fx(mob/living/carbon/user, atom/target)
	refresh_echo_overlay(user)

	// adds overlay
	if(!alignment_overlay)
		alignment_overlay = mutable_appearance(alignment_overlay_icon, alignment_overlay_state, alignment_overlay_layer)
	alignment_overlay.color = alignment_outline_color
	user.add_overlay(alignment_overlay)

/// Refreshes the overlay, because mechanically we want to always keep the user covered, we need to actually reupdate it during various animations (knockdown e.g)
/datum/action/cooldown/power/cultivator/alignment/shadow_walker/proc/refresh_echo_overlay(mob/living/carbon/user)
	// Use the same matrix as echolocation
	var/static/list/black_white_matrix = list(
		85, 85, 85, 0,
		85, 85, 85, 0,
		85, 85, 85, 0,
		0, 0, 0, 1,
		-254, -254, -254, 0
	)
	user.cut_overlay(echo_overlay)
	echo_overlay = new /mutable_appearance(user.icon, user.icon_state)
	echo_overlay.copy_overlays(user)
	echo_overlay.dir = user.dir
	echo_overlay.color = black_white_matrix
	echo_overlay.filters += outline_filter(size = 1, color = COLOR_WHITE)

	echo_overlay.layer = user.layer
	user.add_overlay(echo_overlay)

	// Keep the pulsing outline filter alive through rebuilds.
	user.remove_filter(filter_id)
	user.add_filter(filter_id, 2, outline_filter(size = alignment_outline_size, color = "#ffffff"))
	var/filter = user.get_filter(filter_id)
	if(filter)
		animate(filter, alpha = 110, time = 1.5 SECONDS, loop = -1)
		animate(alpha = 40, time = 2.5 SECONDS)

/// Whenever any held item is changed that would possibly alter the sprite's appearance
/datum/action/cooldown/power/cultivator/alignment/shadow_walker/proc/on_held_items_updated(mob/living/carbon/user)
	SIGNAL_HANDLER
	if(!user)
		return
	refresh_echo_overlay(user)

/// When animation effect occurs.
/datum/action/cooldown/power/cultivator/alignment/shadow_walker/proc/on_transform_updated(mob/living/carbon/user)
	SIGNAL_HANDLER
	if(!user)
		return
	refresh_echo_overlay(user)


/*
	Global identity masking for Shadow Walker alignment.
*/
/datum/shadowwalker_identity
	/// Mob that's being affected by the identity mask
	var/mob/living/carbon/human/owner
	/// Weakref to the owner
	var/datum/weakref/owner_ref
	/// Is it on or not?
	var/active = FALSE

/datum/shadowwalker_identity/New(mob/living/carbon/human/owner_arg)
	. = ..()
	owner = owner_arg
	owner_ref = WEAKREF(owner)
	apply()

/datum/shadowwalker_identity/Destroy()
	clear()
	owner = null
	owner_ref = null
	return ..()

/// Applies various signalers to override info about the mob.
/datum/shadowwalker_identity/proc/apply()
	var/mob/living/carbon/human/owner = src.owner || owner_ref?.resolve()
	if(!istype(owner))
		return
	active = TRUE
	RegisterSignal(owner, COMSIG_HUMAN_GET_VISIBLE_NAME, PROC_REF(on_visible_name))
	RegisterSignal(owner, COMSIG_HUMAN_GET_FORCED_NAME, PROC_REF(on_forced_name))
	RegisterSignal(owner, COMSIG_ATOM_EXAMINE, PROC_REF(on_examine))
	owner.update_visible_name()

/// Removes all traces of the shadowwalker_identity
/datum/shadowwalker_identity/proc/clear()
	var/mob/living/carbon/human/owner = src.owner || owner_ref?.resolve()
	if(owner)
		UnregisterSignal(owner, list(COMSIG_HUMAN_GET_VISIBLE_NAME, COMSIG_HUMAN_GET_FORCED_NAME, COMSIG_ATOM_EXAMINE))
		owner.update_visible_name()
	active = FALSE

/// When a mob gets the visible name of the mob
/datum/shadowwalker_identity/proc/on_visible_name(mob/living/carbon/human/source, list/identity)
	SIGNAL_HANDLER
	if(!active)
		return
	if(identity[VISIBLE_NAME_FORCED])
		return
	identity[VISIBLE_NAME_FACE] = "Unknown"
	identity[VISIBLE_NAME_ID] = "Unknown"

/// WHen a mob gets the visible name of the mob; this ones route a littel differently so we have to call both.
/datum/shadowwalker_identity/proc/on_forced_name(mob/living/carbon/human/source, list/identity)
	SIGNAL_HANDLER
	if(!active)
		return
	identity[VISIBLE_NAME_FORCED] = INFINITY
	identity[VISIBLE_NAME_FACE] = "Unknown"
	identity[VISIBLE_NAME_ID] = "Unknown"

/// When a mob attempts to examine our owner.
/datum/shadowwalker_identity/proc/on_examine(datum/source, mob/user, list/examine_list)
	SIGNAL_HANDLER
	if(!active)
		return NONE
	examine_list.Cut()
	examine_list += span_warning("It's too shrouded in shadow to make out any details.")
	return NONE
