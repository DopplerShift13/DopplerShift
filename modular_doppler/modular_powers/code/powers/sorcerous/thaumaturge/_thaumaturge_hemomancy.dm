/datum/component/thaumaturge_hemomancy
	dupe_mode = COMPONENT_DUPE_UNIQUE

	/// The mob we're attached to is always `parent`.
	var/mob/living/attached_mob
	/// HUD element that shows current blood amount.
	var/atom/movable/screen/hemophage/blood/blood_tracker
	/// Multiplier for converting prep_cost into blood cost.
	var/blood_cost_multiplier = 4

/datum/component/thaumaturge_hemomancy/Initialize(mob/living/new_attached_mob)
	. = ..()
	if(!isliving(parent))
		return COMPONENT_INCOMPATIBLE
	attached_mob = new_attached_mob || parent
	// Mob-level power use hook for overcast affinity rider.
	RegisterSignal(attached_mob, COMSIG_POWER_ACTION_USED, PROC_REF(on_mob_power_action_used))
	// Mob-level power success hook; keeps this component decoupled from per-action registration.
	RegisterSignal(attached_mob, COMSIG_POWER_ACTION_SUCCESS, PROC_REF(on_mob_power_action_success))

	// Procs & trackers for blood UI
	RegisterSignal(attached_mob, COMSIG_LIVING_LIFE, PROC_REF(on_owner_life))
	RegisterSignal(attached_mob, COMSIG_MOB_LOGIN, PROC_REF(on_owner_login))
	sync_root_resource_display_multiplier()
	ensure_blood_tracker()
	update_blood_tracker()

// Removes all signalers.
/datum/component/thaumaturge_hemomancy/Destroy(force)
	if(attached_mob)
		UnregisterSignal(attached_mob, list(COMSIG_POWER_ACTION_USED, COMSIG_POWER_ACTION_SUCCESS, COMSIG_LIVING_LIFE, COMSIG_MOB_LOGIN))
	clear_blood_tracker()
	return ..()

/// Syncs the hemomancy root's displayed resource multiplier to this component's blood cost multiplier.
/datum/component/thaumaturge_hemomancy/proc/sync_root_resource_display_multiplier()
	if(!attached_mob)
		return
	for(var/datum/power/thaumaturge_root/hemomancy/root_power as anything in attached_mob.powers)
		root_power.resource_display_multiplier = blood_cost_multiplier
		break

/// Ensures the blood HUD is visible on our UI.
/datum/component/thaumaturge_hemomancy/proc/ensure_blood_tracker()
	// Stop if mob has no HUD or already has a blood tracker
	if(!attached_mob?.hud_used || blood_tracker)
		return
	var/datum/hud/hud_used = attached_mob.hud_used

	// Delete the existing tracker from hemophages and substitue our own cause ours is BETTER (and tracks more things)
	for(var/atom/movable/screen/screen_obj as anything in hud_used.infodisplay)
		if(!istype(screen_obj, /atom/movable/screen/hemophage/blood))
			continue
		var/atom/movable/screen/hemophage/blood/existing_tracker = screen_obj
		if(existing_tracker == blood_tracker)
			continue
		hud_used.infodisplay -= existing_tracker
		qdel(existing_tracker)

	// Adds the bloodtracker if there is none.
	if(blood_tracker)
		return
	blood_tracker = new /atom/movable/screen/hemophage/blood(null, hud_used)
	hud_used.infodisplay += blood_tracker
	attached_mob.hud_used.show_hud(attached_mob.hud_used.hud_version)

// Updates
/datum/component/thaumaturge_hemomancy/proc/update_blood_tracker()
	if(!attached_mob || !blood_tracker)
		return
	var/normal_blood_volume = BLOOD_VOLUME_NORMAL
	var/hud_color = "#FFDDDD"
	if(normal_blood_volume > 0)
		// Turn green if we can 'overcast'
		if(attached_mob.blood_volume >= normal_blood_volume * THAUMATURGE_HEMOMANCY_OVERCAST_THRESHOLD)
			hud_color = "#83d46f"
		// Turns red if we are in the danger zone.
		else if(attached_mob.blood_volume <= normal_blood_volume * THAUMATURGE_HEMOMANCY_LOW_BLOOD_THRESHOLD)
			hud_color = "#eb6b6b"
	blood_tracker.maptext = MAPTEXT("<div align='center' valign='middle' style='position:relative; top:0px; left:6px'><font color='[hud_color]'>[trunc(attached_mob.blood_volume)]</font></div>")

/// Removes the blood tracker UI element
/datum/component/thaumaturge_hemomancy/proc/clear_blood_tracker()
	if(!blood_tracker)
		return
	if(attached_mob?.hud_used)
		attached_mob.hud_used.infodisplay -= blood_tracker
	QDEL_NULL(blood_tracker)

/// Updates on mob life
/datum/component/thaumaturge_hemomancy/proc/on_owner_life(mob/living/source, seconds_per_tick, times_fired)
	SIGNAL_HANDLER
	ensure_blood_tracker()
	update_blood_tracker()

/// Updates on owner login.
/datum/component/thaumaturge_hemomancy/proc/on_owner_login(mob/living/source)
	SIGNAL_HANDLER
	ensure_blood_tracker()
	update_blood_tracker()

/// Gets the blood cost for a thaumaturge action.
/datum/component/thaumaturge_hemomancy/proc/get_blood_cost(datum/action/cooldown/power/thaumaturge/action)
	if(!action)
		return 0
	return max(0, action.prep_cost * blood_cost_multiplier)

/// Subtracts the appropriate amount of blood from the mob.
/datum/component/thaumaturge_hemomancy/proc/consume_action_cost(datum/action/cooldown/power/thaumaturge/action, mob/living/user)
	if(!action || !user)
		return
	action.ValidateThaumaturgeRoot()
	if(action.associated_root_power?.charge_mechanics)
		return
	var/blood_cost = get_blood_cost(action)
	if(blood_cost <= 0)
		return
	if(user.blood_volume < blood_cost)
		user.balloon_alert(user, "not enough blood!")
		return
	user.blood_volume = max(user.blood_volume - blood_cost, 0)

/// During action use, repeatedly consume spell cost above threshold to boost affinity for this cast.
/datum/component/thaumaturge_hemomancy/proc/on_mob_power_action_used(mob/living/source, datum/action/cooldown/power/action, atom/target)
	SIGNAL_HANDLER
	// Definitions and validations
	var/datum/action/cooldown/power/thaumaturge/thaum_action = action
	if(!istype(thaum_action))
		return
	thaum_action.ValidateThaumaturgeRoot()
	if(thaum_action.associated_root_power?.charge_mechanics)
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
/datum/component/thaumaturge_hemomancy/proc/on_mob_power_action_success(mob/living/source, datum/action/cooldown/power/action, atom/target)
	SIGNAL_HANDLER
	var/datum/action/cooldown/power/thaumaturge/thaum_action = action
	if(!istype(thaum_action))
		return
	consume_action_cost(thaum_action, source)
