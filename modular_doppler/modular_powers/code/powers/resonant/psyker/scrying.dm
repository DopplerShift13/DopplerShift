/*
	Lets you use blood to scry someone. Really potent for detectives and the likes; but has a massive laundry list of things that disable it.
*/

/datum/power/psyker_power/scrying
	name = "Scrying"
	desc = "Using a sample of a creature's blood, you can see the world through their eyes remotely. Creatures will be vague and hard to distinguish, but their environment will appear clear. \
	In this state, you use their sight instead of your own; but you cannot target creatures that are immune to magic, scrying; or lack the brain activity required to be detectable (dumb). \
	Passively builds up stress. The target sometimes gets preminations to indicate they are watched."
	security_record_text = "Subject can psychically observe people's locations based on blood samples from extreme distances."
	value = 10
	action_path = /datum/action/cooldown/power/psyker/scrying

/datum/action/cooldown/power/psyker/scrying
	name = "Scrying"
	desc = "Using a sample of a creature's blood, you can see the world through their eyes remotely."
	button_icon = 'icons/mob/actions/actions_animal.dmi'
	button_icon_state = "gaze"
	click_to_activate = TRUE
	target_range = 1

	/// The target we are currently scrying
	var/atom/movable/scry_target

	// This thing is a MESS. We have split functionality into three datums.
	/// Scrying Camera which handles imparting the sight of the target
	var/datum/scrying_camera/scry_camera
	/// Scrying Vision which handles vision traits on the user.
	var/datum/scrying_vision/scry_vision
	/// Scrying Immunity Mask which hides people into indistinct overlays.
	var/datum/scrying_immunity_mask/immunity_mask
	/// and Scrying Tracker which basically handles any and all things related to stress gain.
	var/datum/psyker_scry_tracker/tracker

/datum/action/cooldown/power/psyker/scrying/Trigger(mob/clicker, trigger_flags, atom/target)
	if(active)
		end_scrying()
		to_chat(owner, span_notice("Your sight returns as you focus back on your own mind."))
	else
		. = ..()
	return TRUE

/*
	Most of the delegation with scrying is handled by scry_vision. We simply verify here and build the datums used.
*/
/datum/action/cooldown/power/psyker/scrying/use_action(mob/living/user, atom/target)
	var/list/dna_samples = get_blood_dna_list_from_target(target)
	if(!length(dna_samples))
		to_chat(user, span_warning("You need blood to focus your scrying."))
		return FALSE

	// If your list of dna samples has multiples then my man you gotta clean your samples. Chooses a random one.
	var/selected_dna = pick(dna_samples)
	var/mob/living/chosen_target = find_scry_target_from_dna(selected_dna)
	if(!chosen_target)
		to_chat(user, span_warning("No mind to link to."))
		return FALSE

	if(!can_affect_scrying(chosen_target))
		to_chat(user, span_warning("Your sight cannot find purchase on that mind."))
		return FALSE

	active = TRUE

	scry_target = chosen_target
	// We create the new datums which will immediately handle their effects.
	scry_camera = new(user, scry_target, src)
	scry_vision = new(user)
	tracker = new(src, user)
	immunity_mask = new(src, user, scry_camera.scry_eye)
	immunity_mask.refresh_now()

	// Bit of psyker stress on use ontop of the processing cost just to prevent too much spam peeking.
	modify_stress(PSYKER_STRESS_MINOR * 1.5)

	playsound(user, 'sound/effects/magic/swap.ogg', 75, TRUE, SILENCED_SOUND_EXTRARANGE)

	// Adds listeners for dispelling on the target
	RegisterSignal(scry_target, COMSIG_ATOM_DISPEL, PROC_REF(on_dispel))
	return TRUE

// Dispel signalers
/datum/action/cooldown/power/psyker/scrying/Grant(mob/granted_to)
	. = ..()
	if(resonant)
		RegisterSignal(granted_to, COMSIG_ATOM_DISPEL, PROC_REF(on_dispel))

/datum/action/cooldown/power/psyker/scrying/Remove(mob/removed_from)
	. = ..()
	if(resonant)
		UnregisterSignal(removed_from, COMSIG_ATOM_DISPEL)
	end_scrying()

/// Dispel proc ends the scrying
/datum/action/cooldown/power/psyker/scrying/proc/on_dispel(mob/owner, atom/dispeller)
	SIGNAL_HANDLER
	if(active)
		to_chat(owner, span_warning("Your scrying link was cut off!"))
		end_scrying()

/// Gets DNA from blood
/datum/action/cooldown/power/psyker/scrying/proc/get_blood_dna_list_from_target(atom/target)
	if(isnull(target))
		return null

	var/list/dna_list = list()

	if(ismob(target))
		return dna_list

	// Gets dna from a blood decal.
	if(istype(target, /obj/effect/decal/cleanable/blood))
		var/list/blood = GET_ATOM_BLOOD_DNA(target)
		for(var/dna in blood)
			dna_list += dna
		return dna_list

	// Gets dna from blood from reagent containers. Note: There's a bug with scraping blood not saving DNA; so if it acts weirds its likely that (as of 20/02/26)
	if(istype(target, /obj/item/reagent_containers))
		for(var/datum/reagent/present_reagent as anything in target.reagents?.reagent_list)
			if(!istype(present_reagent, /datum/reagent/blood))
				continue
			var/blood_dna = present_reagent.data?["blood_DNA"]
			if(isnull(blood_dna))
				continue
			if(islist(blood_dna))
				for(var/dna in blood_dna)
					dna_list += dna
			else
				dna_list += blood_dna

	// Any non-mob atom with forensics blood on it (e.g. clothes, tools)
	var/list/blood = GET_ATOM_BLOOD_DNA(target)
	if(length(blood))
		for(var/dna in blood)
			dna_list += dna

	return dna_list

///	 Checks the blood for a dna match.
/datum/action/cooldown/power/psyker/scrying/proc/find_scry_target_from_dna(selected_dna)
	if(!selected_dna)
		return null

	for(var/mob/living/target in GLOB.mob_list)
		if(isobserver(target))
			continue
		var/list/blood_dna = target.get_blood_dna_list()
		if(blood_dna && blood_dna[selected_dna])
			return target
	return null

/// called by everything that ends scrying; removes all the datums and left over signalers.
/datum/action/cooldown/power/psyker/scrying/proc/end_scrying()
	if(!active)
		return

	active = FALSE

	QDEL_NULL(tracker)
	QDEL_NULL(scry_vision)
	QDEL_NULL(scry_camera)
	QDEL_NULL(immunity_mask)

	// removes dispel signal from target
	UnregisterSignal(scry_target, COMSIG_ATOM_DISPEL)

	scry_target = null



/*
	We bypass our own vision traits and see the world from the target's pov.
	Handles the removal of vision traits and the application of the overlay.
*/
/datum/scrying_vision
	/// Used to remove/re-add quirk blindness safely.
	var/had_blind_quirk = FALSE
	/// Weakref to the viewer mob
	var/datum/weakref/viewer_ref

/datum/scrying_vision/New(mob/living/viewer)
	. = ..()
	viewer_ref = WEAKREF(viewer)
	apply()

/datum/scrying_vision/Destroy()
	clear()
	viewer_ref = null
	return ..()

/// Applies vision modifiers such as removing blindness quirk vision, as well as adding thecurse overlay.
/datum/scrying_vision/proc/apply()
	var/mob/living/viewer = viewer_ref?.resolve()
	if(!istype(viewer))
		return

	// If blindness is being enforced by the blind quirk, we temporarily remove it.
	if(viewer.is_blind_from(QUIRK_TRAIT))
		had_blind_quirk = TRUE
		viewer.remove_status_effect(/datum/status_effect/grouped/blindness, QUIRK_TRAIT)

	ADD_TRAIT(viewer, TRAIT_SIGHT_BYPASS, REF(src))

	// Restrict vision partially.
	viewer.overlay_fullscreen("curse", /atom/movable/screen/fullscreen/curse, 1)
	viewer.update_sight()

/// Removes the things applied in apply()
/datum/scrying_vision/proc/clear()
	var/mob/living/viewer = viewer_ref?.resolve()
	if(!istype(viewer))
		return

	viewer.clear_fullscreen("curse", 50)

	REMOVE_TRAIT(viewer, TRAIT_SIGHT_BYPASS, REF(src))

	// Restore the blind quirk's blindness if we removed it.
	if(had_blind_quirk)
		viewer.become_blind(QUIRK_TRAIT)

	had_blind_quirk = FALSE
	viewer.update_sight()

/*
	This sets the player's perspective to a scry eye that follows the target.
*/
/datum/scrying_camera
	/// Weakref to the viewer mob
	var/datum/weakref/viewer_ref
	/// Weakref to the target mob
	var/datum/weakref/target_ref
	/// Weakref to the power action
	var/datum/weakref/action_ref
	/// Weakref to the mob/eye that handles the vision
	var/mob/eye/psyker_scry/scry_eye


/datum/scrying_camera/New(mob/living/viewer, atom/movable/target, datum/action/cooldown/power/psyker/scrying/action)
	. = ..()
	viewer_ref = WEAKREF(viewer)
	target_ref = WEAKREF(target)
	action_ref = WEAKREF(action)

	var/turf/target_turf = get_turf(target)
	if(!target_turf)
		qdel(src)
		return

	scry_eye = new(target_turf)
	scry_eye.set_target(target)
	scry_eye.assign_user(viewer)

	RegisterSignals(target, list(COMSIG_MOVABLE_MOVED, COMSIG_QDELETING), PROC_REF(on_target_event))

/datum/scrying_camera/Destroy()
	var/atom/movable/target = target_ref?.resolve()
	if(target)
		UnregisterSignal(target, list(COMSIG_MOVABLE_MOVED, COMSIG_QDELETING))

	if(scry_eye)
		scry_eye.assign_user(null)
		QDEL_NULL(scry_eye)

	viewer_ref = null
	target_ref = null
	return ..()

/// Called by the moved and qdeleted signaler, updating the scrying eye's location or removing it if qdeled
/datum/scrying_camera/proc/on_target_event(datum/source)
	SIGNAL_HANDLER

	if(!scry_eye || QDELETED(scry_eye))
		qdel(src)
		return

	var/atom/movable/target = target_ref?.resolve()
	if(QDELETED(target) || !ismovable(target))
		qdel(src)
		return

	var/turf/target_turf = get_turf(target)
	if(target_turf)
		scry_eye.setLoc(target_turf)
		var/datum/action/cooldown/power/psyker/scrying/action = action_ref?.resolve()
		action?.immunity_mask?.refresh_now()



/*
	Tracker just adds stress and handles proccessing.
*/
/datum/psyker_scry_tracker
	/// Weakref to the power action
	var/datum/weakref/action_ref
	/// Weakref to the power's owner
	var/datum/weakref/owner_ref

/datum/psyker_scry_tracker/New(datum/action/cooldown/power/psyker/scrying/action, mob/living/owner)
	. = ..()
	action_ref = WEAKREF(action)
	owner_ref = WEAKREF(owner)
	START_PROCESSING(SSfastprocess, src)

/datum/psyker_scry_tracker/Destroy()
	STOP_PROCESSING(SSfastprocess, src)
	return ..()

/datum/psyker_scry_tracker/process(seconds_per_tick)
	var/datum/action/cooldown/power/psyker/scrying/action = action_ref?.resolve()
	if(!action || !action.active)
		qdel(src)
		return

	var/mob/living/owner = owner_ref?.resolve()
	if(!owner)
		action.end_scrying()
		qdel(src)
		return

	var/atom/movable/current_target = action.scry_target
	if(current_target && !action.can_affect_scrying(current_target))
		action.end_scrying()
		to_chat(owner, span_warning("Your scrying link was cut off!"))
		qdel(src)
		return

	// Random chance for the target to feel a chill down their spine.
	if(ismob(current_target))
		var/mob/target_mob = current_target
		if(prob((seconds_per_tick / 30) * 100))
			to_chat(target_mob, span_warning("A shudder runs down your spine, as if you're being watched."))

	// Applies stress. On the trope of having cripple quirks for psyker, being blind halves your stress upkeep.
	if(owner.has_quirk(/datum/quirk/item_quirk/blindness))
		action.modify_stress((PSYKER_STRESS_MINOR * seconds_per_tick) / 4) // handicap discount
	else
		action.modify_stress((PSYKER_STRESS_MINOR * seconds_per_tick) / 2) // normal people cost

	// Re-apply in case other systems reassert blindness/quirk/etc.
	if(action.scry_vision)
		action.scry_vision.apply()

/*
	Used to mask mobs from the scrying eye.
*/
/datum/scrying_immunity_mask
	/// Weakref to the viewer mob
	var/datum/weakref/viewer_ref
	/// Weakref to the mob eye
	var/datum/weakref/eye_ref
	/// Weakref to the power action
	var/datum/weakref/action_ref

	/// mob -> mask_image
	var/list/masked_mobs = list()

/datum/scrying_immunity_mask/New(datum/action/cooldown/power/psyker/scrying/action, mob/living/viewer, mob/eye/psyker_scry/eye)
	. = ..()
	action_ref = WEAKREF(action)
	viewer_ref = WEAKREF(viewer)
	eye_ref = WEAKREF(eye)

	if(viewer)
		viewer.mob_flags |= MOB_HAS_SCREENTIPS_NAME_OVERRIDE
		RegisterSignal(viewer, COMSIG_MOB_REQUESTING_SCREENTIP_NAME_FROM_USER, PROC_REF(screentip_name_override))
		RegisterSignal(viewer, COMSIG_LIVING_PERCEIVE_EXAMINE_NAME, PROC_REF(examine_name_override))

	START_PROCESSING(SSfastprocess, src)

/datum/scrying_immunity_mask/Destroy()
	STOP_PROCESSING(SSfastprocess, src)
	var/mob/living/viewer = viewer_ref?.resolve()
	if(viewer)
		UnregisterSignal(viewer, list(COMSIG_MOB_REQUESTING_SCREENTIP_NAME_FROM_USER, COMSIG_LIVING_PERCEIVE_EXAMINE_NAME))
	clear_all()
	return ..()

/datum/scrying_immunity_mask/process(seconds_per_tick)
	var/datum/action/cooldown/power/psyker/scrying/action = action_ref?.resolve()
	var/mob/living/viewer = viewer_ref?.resolve()
	var/mob/eye/psyker_scry/eye = eye_ref?.resolve()

	if(!action || !action.active || !viewer || !viewer.client || !eye)
		qdel(src)
		return

	update_masks(viewer, eye, action)

/// Proc that signals update_masks() and forces a refresh of all the masks
/datum/scrying_immunity_mask/proc/refresh_now()
	var/datum/action/cooldown/power/psyker/scrying/action = action_ref?.resolve()
	var/mob/living/viewer = viewer_ref?.resolve()
	var/mob/eye/psyker_scry/eye = eye_ref?.resolve()
	if(!action || !action.active || !viewer || !viewer.client || !eye)
		return

	update_masks(viewer, eye, action)

/// Gets every mob in view and applies an alpha'd mask to all mobs.
/datum/scrying_immunity_mask/proc/update_masks(mob/living/viewer, mob/eye/psyker_scry/eye, datum/action/cooldown/power/psyker/scrying/action)
	var/list/current_mobs = list()
	for(var/mob/living/seen_mob in view(viewer.client.view, eye))
		current_mobs += seen_mob

	// Remove masks for mobs no longer in view (or deleted)
	for(var/mob/living/masked_mob as anything in masked_mobs.Copy())
		if(QDELETED(masked_mob) || !(masked_mob in current_mobs))
			unmask_mob(viewer, masked_mob)

	// Apply masks for newly seen mobs (baseline: everyone)
	for(var/mob/living/seen_mob as anything in current_mobs)
		if(masked_mobs[seen_mob])
			sync_mask_image(seen_mob)
			continue

		mask_mob(viewer, seen_mob)

/// Keep silhouettes aligned with the target's current appearance (transform/pixel offsets/dir).
/datum/scrying_immunity_mask/proc/sync_mask_image(mob/living/target_mob)
	var/image/mask_image = masked_mobs[target_mob]
	if(!mask_image)
		return
	// Copy the full appearance so transforms and pixel offsets stay in sync.
	mask_image.appearance = target_mob.appearance
	mask_image.override = TRUE
	mask_image.name = "Unknown"
	mask_image.color = "#000000"
	mask_image.alpha = 180
	mask_image.appearance_flags |= RESET_TRANSFORM
	mask_image.dir = target_mob.dir
	// Avoid double-applying mob pixel offsets; the image is already anchored to the mob.
	mask_image.pixel_w = 0
	mask_image.pixel_x = 0
	mask_image.pixel_y = 0
	mask_image.pixel_z = 0
	SET_PLANE_EXPLICIT(mask_image, ABOVE_GAME_PLANE, target_mob)

/// Applies the alpha mob mask, turning them into a see-trhrough silhouette
/datum/scrying_immunity_mask/proc/mask_mob(mob/living/viewer, mob/living/target_mob)
	if(!viewer?.client || QDELETED(target_mob))
		return

	// Delusion-style hallucination override: a client-only mask image that owns the click/name.
	var/image/mask_image = image(loc = target_mob)
	mask_image.appearance = target_mob.appearance
	mask_image.override = TRUE
	mask_image.name = "Unknown"
	mask_image.color = "#000000"
	mask_image.alpha = 180
	mask_image.appearance_flags |= RESET_TRANSFORM
	mask_image.dir = target_mob.dir
	// Avoid double-applying mob pixel offsets; the image is already anchored to the mob.
	mask_image.pixel_w = 0
	mask_image.pixel_x = 0
	mask_image.pixel_y = 0
	mask_image.pixel_z = 0
	SET_PLANE_EXPLICIT(mask_image, ABOVE_GAME_PLANE, target_mob)

	viewer.client.images += mask_image
	masked_mobs[target_mob] = mask_image

	// Hides data about the mob with vague examines + no huds.
	RegisterSignal(target_mob, COMSIG_ATOM_EXAMINE, PROC_REF(on_target_examine))
	hide_data_huds(viewer, target_mob)

/// Removes mob masking from a target
/datum/scrying_immunity_mask/proc/unmask_mob(mob/living/viewer, mob/living/target_mob)
	var/image/mask_image = masked_mobs[target_mob]
	if(!mask_image)
		return

	if(viewer?.client)
		viewer.client.images -= mask_image

	UnregisterSignal(target_mob, COMSIG_ATOM_EXAMINE)
	unhide_data_huds(viewer, target_mob)
	masked_mobs -= target_mob

/// Clears all mob masks on the target
/datum/scrying_immunity_mask/proc/clear_all()
	var/mob/living/viewer = viewer_ref?.resolve()
	if(!viewer?.client)
		masked_mobs.Cut()
		return

	for(var/mob/living/masked_mob as anything in masked_mobs.Copy())
		unmask_mob(viewer, masked_mob)

/// Overrides the examine text of the target to be vague.
/datum/scrying_immunity_mask/proc/on_target_examine(datum/source, mob/user, list/examine_list)
	SIGNAL_HANDLER

	var/mob/living/viewer = viewer_ref?.resolve()
	if(user != viewer)
		return NONE

	if(!istype(source, /mob/living) || !masked_mobs[source])
		return NONE

	examine_list.Cut()
	examine_list += span_notice("It's too hazy to make out details.")
	return NONE

/// Hides all glasses HUDs from the target mob.
/datum/scrying_immunity_mask/proc/hide_data_huds(mob/living/viewer, mob/living/target_mob)
	if(!viewer || !target_mob)
		return
	for(var/datum/atom_hud/hud as anything in GLOB.huds)
		hud.hide_single_atomhud_from(viewer, target_mob)

/// Unhides all glasses HUDs from the target mob
/datum/scrying_immunity_mask/proc/unhide_data_huds(mob/living/viewer, mob/living/target_mob)
	if(!viewer || !target_mob)
		return
	for(var/datum/atom_hud/hud as anything in GLOB.huds)
		hud.unhide_single_atomhud_from(viewer, target_mob)

/// Forcefully overrides the examine name of the target.
/datum/scrying_immunity_mask/proc/examine_name_override(datum/source, mob/living/examined, visible_name, list/name_override)
	SIGNAL_HANDLER

	if(!istype(examined) || !masked_mobs[examined])
		return NONE

	name_override[1] = "Unknown"
	return COMPONENT_EXAMINE_NAME_OVERRIDEN

/// Forcefully overrides the top portion screentip of the mob's name.
/datum/scrying_immunity_mask/proc/screentip_name_override(datum/source, list/returned_name, obj/item/held_item, atom/hovered)
	SIGNAL_HANDLER

	if(!istype(hovered) || !masked_mobs[hovered])
		return NONE

	returned_name[1] = "Unknown"
	return SCREENTIP_NAME_SET


/*
	Scry eye mob: purely perspective anchor.
*/
/mob/eye/psyker_scry
	name = "scrying eye"
	/// Weakref to the user that's seeing through the mob eye
	var/datum/weakref/user_ref
	/// Weakref to the target we're following
	var/datum/weakref/target_ref

/mob/eye/psyker_scry/Destroy()
	assign_user(null)
	return ..()

/// Assigns the mob we're following.
/mob/eye/psyker_scry/proc/assign_user(mob/living/new_user)
	var/mob/living/old_user = user_ref?.resolve()
	if(old_user)
		old_user.reset_perspective(null)
		name = initial(src.name)

	user_ref = WEAKREF(new_user)

	if(new_user)
		new_user.reset_perspective(src)
		name = "Scrying Eye ([new_user.name])"

/// Sets our target weakref
/mob/eye/psyker_scry/proc/set_target(atom/movable/target)
	target_ref = WEAKREF(target)

/// Updates the location of the mob eye.
/mob/eye/psyker_scry/proc/setLoc(turf/destination, force_update = FALSE)
	if(destination)
		forceMove(destination)
