/datum/component/thaumaturge/hemomancy
	dupe_mode = COMPONENT_DUPE_UNIQUE

	charge_mechanics = FALSE
	affinity_benefits_from_items = FALSE
	charges_color = "#c72222"
	resource_display_mode = THAUMATURGE_RESOURCE_DISPLAY_PREP_COST
	additional_magic_resistance_flags = MAGIC_RESISTANCE_HOLY
	resource_display_multiplier = THAUMATURGE_HEMOMANCY_BLOOD_COST_MULTIPLIER

	/// HUD element that shows current blood amount.
	var/atom/movable/screen/hemophage/blood/blood_tracker
	/// Multiplier for converting prep_cost into blood cost.
	var/blood_cost_multiplier = THAUMATURGE_HEMOMANCY_BLOOD_COST_MULTIPLIER


/datum/component/thaumaturge/hemomancy/Initialize(mob/living/new_attached_mob)
	. = ..(new_attached_mob)
	// Mob-level power use hook for overcast affinity rider.
	RegisterSignal(attached_mob, COMSIG_POWER_ACTION_USED, PROC_REF(on_mob_power_action_used))
	// Mob-level power success hook; keeps this component decoupled from per-action registration.
	RegisterSignal(attached_mob, COMSIG_POWER_ACTION_SUCCESS, PROC_REF(on_mob_power_action_success))

	// Procs & trackers for blood UI
	RegisterSignal(attached_mob, COMSIG_LIVING_LIFE, PROC_REF(on_owner_life))
	RegisterSignal(attached_mob, COMSIG_MOB_LOGIN, PROC_REF(on_owner_login))

	// Updates to the blood tracker
	ensure_blood_tracker()
	update_blood_tracker()

// Removes all signalers.
/datum/component/thaumaturge/hemomancy/Destroy(force)
	if(attached_mob)
		UnregisterSignal(attached_mob, list(COMSIG_POWER_ACTION_USED, COMSIG_POWER_ACTION_SUCCESS, COMSIG_LIVING_LIFE, COMSIG_MOB_LOGIN))
	clear_blood_tracker()
	return ..()

/// Ensures the blood HUD is visible on our UI.
/datum/component/thaumaturge/hemomancy/proc/ensure_blood_tracker()
	// Stop if mob has no HUD.
	if(!attached_mob?.hud_used)
		return
	var/datum/hud/hud_used = attached_mob.hud_used

	// Always delete competing hemophage trackers so ours stays authoritative.
	for(var/atom/movable/screen/hemophage/blood/existing_tracker as anything in hud_used.infodisplay)
		if(existing_tracker == blood_tracker)
			continue
		hud_used.infodisplay -= existing_tracker
		qdel(existing_tracker)

	// If our tracker was qdeleted externally, clear stale ref.
	if(QDELETED(blood_tracker))
		blood_tracker = null

	// Create ours if missing.
	if(!blood_tracker)
		blood_tracker = new /atom/movable/screen/hemophage/blood(null, hud_used)

	// Ensure ours is in infodisplay.
	if(!(blood_tracker in hud_used.infodisplay))
		hud_used.infodisplay += blood_tracker

	attached_mob.hud_used.show_hud(attached_mob.hud_used.hud_version)

/// Updates the blood tracker with new numbers +
/datum/component/thaumaturge/hemomancy/proc/update_blood_tracker()
	if(!attached_mob || !blood_tracker)
		return
	var/hud_color = "#FFDDDD"
	// Turn green if we can 'overcast'
	if(attached_mob.blood_volume >= BLOOD_VOLUME_NORMAL * THAUMATURGE_HEMOMANCY_OVERCAST_THRESHOLD)
		hud_color = "#83d46f"
	// Turns red if we are in the danger zone.
	else if(attached_mob.blood_volume <= BLOOD_VOLUME_NORMAL * THAUMATURGE_HEMOMANCY_LOW_BLOOD_THRESHOLD)
		hud_color = "#eb6b6b"
	blood_tracker.maptext = MAPTEXT("<div align='center' valign='middle' style='position:relative; top:0px; left:6px'><font color='[hud_color]'>[trunc(attached_mob.blood_volume)]</font></div>")

/// Removes the blood tracker UI element
/datum/component/thaumaturge/hemomancy/proc/clear_blood_tracker()
	if(!blood_tracker)
		return
	if(attached_mob?.hud_used)
		attached_mob.hud_used.infodisplay -= blood_tracker
	QDEL_NULL(blood_tracker)

/// Updates on mob life
/datum/component/thaumaturge/hemomancy/proc/on_owner_life(mob/living/source, seconds_per_tick, times_fired)
	SIGNAL_HANDLER
	ensure_blood_tracker()
	update_blood_tracker()

/// Updates on owner login.
/datum/component/thaumaturge/hemomancy/proc/on_owner_login(mob/living/source)
	SIGNAL_HANDLER
	ensure_blood_tracker()
	update_blood_tracker()

/// Gets the blood cost for a thaumaturge action.
/datum/component/thaumaturge/hemomancy/proc/get_blood_cost(datum/action/cooldown/power/thaumaturge/action)
	if(!action)
		return 0
	return max(0, action.prep_cost * blood_cost_multiplier)

/// Subtracts the appropriate amount of blood from the mob.
/datum/component/thaumaturge/hemomancy/proc/consume_action_cost(datum/action/cooldown/power/thaumaturge/action, mob/living/user)
	if(!action || !user)
		return
	action.ValidateThaumaturgeComponent()
	if(action.thaumaturge_component?.charge_mechanics)
		return
	var/blood_cost = get_blood_cost(action)
	if(blood_cost <= 0)
		return
	if(user.blood_volume < blood_cost)
		user.balloon_alert(user, "not enough blood!")
		return
	user.blood_volume = max(user.blood_volume - blood_cost, 0)

/// During action use, repeatedly consume spell cost above threshold to boost affinity for this cast.
/datum/component/thaumaturge/hemomancy/proc/on_mob_power_action_used(mob/living/source, datum/action/cooldown/power/action, atom/target)
	SIGNAL_HANDLER
	// Definitions and validations
	var/datum/action/cooldown/power/thaumaturge/thaum_action = action
	if(!istype(thaum_action))
		return
	thaum_action.ValidateThaumaturgeComponent()
	if(thaum_action.thaumaturge_component?.charge_mechanics)
		return
	// Overcasting is disabled for powers that use refund mechanics.
	if(thaum_action.power_refunds)
		return

	// Gets the cost of the ability
	var/spell_cost = get_blood_cost(thaum_action)
	if(spell_cost <= 0)
		return

	// Sets the overcast threshold
	var/overcast_threshold = BLOOD_VOLUME_NORMAL * THAUMATURGE_HEMOMANCY_OVERCAST_THRESHOLD
	if(source.blood_volume < overcast_threshold) // if we aren't at the threshold, no overcasting.
		return

	// Overcasting
	var/current_affinity = isnum(thaum_action.affinity) ? thaum_action.affinity : 0
	// Attempts to overcast by repeatedly paying spell cost while above threshold.
	while(source.blood_volume >= overcast_threshold && source.blood_volume >= spell_cost && current_affinity < THAUMATURGE_HEMOMANCY_MAX_AFFINITY)
		source.blood_volume = max(source.blood_volume - spell_cost, 0)
		current_affinity++

	thaum_action.affinity = current_affinity

/// Chargeless thaumaturge actions consume blood on successful use.
/datum/component/thaumaturge/hemomancy/proc/on_mob_power_action_success(mob/living/source, datum/action/cooldown/power/action, atom/target)
	SIGNAL_HANDLER
	var/datum/action/cooldown/power/thaumaturge/thaum_action = action
	if(!istype(thaum_action))
		return
	consume_action_cost(thaum_action, source)
