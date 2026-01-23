
/datum/power/psyker_power/telekinesis
	name = "Telekinesis"
	desc = "Grants you temporary telekinetic powers. Passively increases stress while active."

	value = 5
	priority = POWER_PRIORITY_BASIC
	required_powers = list(/datum/power/psyker_root)
	action_path = /datum/action/cooldown/spell/pointed/telekinesis

/datum/action/cooldown/spell/pointed/telekinesis
	name = "Telekinesis"
	desc = "Middle-click to grab an object. Middle-click again to drop."
	button_icon = 'icons/mob/actions/actions_revenant.dmi'
	button_icon_state = "r_transmit"

	unset_after_click = FALSE
	cast_range = 8
	aim_assist = FALSE
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC
	antimagic_flags = MAGIC_RESISTANCE_MIND

	/// Range of the kinesis grab.
	var/grab_range = 8
	/// Stat required for us to grab a mob.
	var/stat_required = DEAD

	/// Atom we grabbed with kinesis.
	var/atom/movable/grabbed_atom
	/// Ref of the beam following the grabbed atom.
	var/datum/beam/kinesis_beam
	/// Overlay we add to each grabbed atom.
	var/mutable_appearance/kinesis_icon
	/// Mouse movement catcher (for dragging)
	var/atom/movable/screen/fullscreen/cursor_catcher/kinesis/kinesis_catcher


	/// Psyker organ for stress.
	var/obj/item/organ/resonant/psyker/psyker_organ
	var/stress_cost_grab = 6

/datum/action/cooldown/spell/pointed/telekinesis/on_activation(mob/on_who)
	. = ..()
	if(!.)
		return
	psyker_organ = on_who.get_organ_slot(ORGAN_SLOT_PSYKER)
	return TRUE

/datum/action/cooldown/spell/pointed/telekinesis/on_deactivation(mob/on_who, refund_cooldown = TRUE)
	clear_grab(playsound = FALSE)
	psyker_organ = null
	return ..()

/datum/action/cooldown/spell/pointed/telekinesis/InterceptClickOn(mob/living/clicker, params, atom/target)
	// We only care about the owner using it
	if(clicker != owner)
		return TRUE

	var/list/modifiers = params2list(params)

	// Only middle click does anything for now
	if(!LAZYACCESS(modifiers, MIDDLE_CLICK))
		return TRUE

	// Middle click: drop if already holding something
	if(grabbed_atom)
		clear_grab()
		return TRUE

	// Otherwise: attempt grab
	if(!target)
		return TRUE

	if(!range_check(clicker, target))
		to_chat(clicker, span_warning("Too far!"))
		return TRUE

	if(!can_grab(clicker, target))
		to_chat(clicker, span_warning("Can't grab that!"))
		return TRUE

	add_stress(stress_cost_grab)
	grab_atom(clicker, target)
	return TRUE

// TODO: Move this to the more universal one in _psyker_power.dm
/datum/action/cooldown/spell/pointed/telekinesis/proc/add_stress(amount)
	if(!amount)
		return
	var/mob/living/user = owner
	if(!psyker_organ && user)
		psyker_organ = user.get_organ_slot(ORGAN_SLOT_PSYKER)
	if(psyker_organ)
		psyker_organ.stress += amount

/datum/action/cooldown/spell/pointed/telekinesis/proc/range_check(mob/living/user, atom/target)
	if(!isturf(user.loc))
		return FALSE
	if(ismovable(target) && !isturf(target.loc))
		return FALSE
	if(!can_see(user, target, grab_range))
		return FALSE
	return TRUE

/datum/action/cooldown/spell/pointed/telekinesis/proc/can_grab(mob/living/user, atom/target)
	if(user == target)
		return FALSE
	if(!ismovable(target))
		return FALSE
	if(iseffect(target))
		return FALSE

	var/atom/movable/movable_target = target
	if(movable_target.anchored)
		return FALSE
	if(movable_target.throwing)
		return FALSE
	if(movable_target.move_resist >= MOVE_FORCE_OVERPOWERING)
		return FALSE

	if(ismob(movable_target))
		if(!isliving(movable_target))
			return FALSE
		var/mob/living/living_target = movable_target
		if(living_target.buckled)
			return FALSE
		if(living_target.stat < stat_required)
			return FALSE
	else if(isitem(movable_target))
		var/obj/item/item_target = movable_target
		if(item_target.w_class >= WEIGHT_CLASS_GIGANTIC)
			return FALSE
		if(item_target.item_flags & ABSTRACT)
			return FALSE

	return TRUE

/datum/action/cooldown/spell/pointed/telekinesis/proc/grab_atom(mob/living/user, atom/movable/target)
	grabbed_atom = target

	if(isliving(grabbed_atom))
		grabbed_atom.add_traits(list(TRAIT_IMMOBILIZED, TRAIT_HANDS_BLOCKED), REF(src))
		RegisterSignal(grabbed_atom, COMSIG_MOB_STATCHANGE, PROC_REF(on_statchange))

	ADD_TRAIT(grabbed_atom, TRAIT_NO_FLOATING_ANIM, REF(src))
	RegisterSignal(grabbed_atom, COMSIG_MOVABLE_SET_ANCHORED, PROC_REF(on_setanchored))

	playsound(grabbed_atom, 'sound/items/weapons/contractor_baton/contractorbatonhit.ogg', 75, TRUE)

	kinesis_icon = mutable_appearance(icon = 'icons/effects/effects.dmi', icon_state = "cursehand0", layer = grabbed_atom.layer - 0.1, appearance_flags = RESET_ALPHA|RESET_COLOR|RESET_TRANSFORM|KEEP_APART)
	kinesis_icon.overlays += emissive_appearance(icon = 'icons/effects/effects.dmi', icon_state = "cursehand0", offset_spokesman = grabbed_atom)
	grabbed_atom.add_overlay(kinesis_icon)

	kinesis_beam = user.Beam(grabbed_atom, "curse0")
	if(!kinesis_catcher)
		kinesis_catcher = user.overlay_fullscreen(
			"curse0",
			/atom/movable/screen/fullscreen/cursor_catcher/kinesis,
			0
		)
		kinesis_catcher.assign_to_mob(user)

	START_PROCESSING(SSfastprocess, src)

/datum/action/cooldown/spell/pointed/telekinesis/process(seconds_per_tick)
	var/mob/living/user = owner
	if(!grabbed_atom || !user?.client)
		STOP_PROCESSING(SSfastprocess, src)
		return

	if(!kinesis_catcher?.mouse_params)
		return

	kinesis_catcher.calculate_params()
	if(!kinesis_catcher.given_turf)
		return

	var/turf/target_turf = kinesis_catcher.given_turf
	if(grabbed_atom.loc == target_turf)
		return

	grabbed_atom.Move(
		get_step_towards(grabbed_atom, target_turf),
		get_dir(grabbed_atom, target_turf),
		8
	)

/datum/action/cooldown/spell/pointed/telekinesis/proc/clear_grab(playsound = TRUE)
	if(!grabbed_atom)
		return

	if(playsound)
		playsound(grabbed_atom, 'sound/effects/empulse.ogg', 75, TRUE)

	UnregisterSignal(grabbed_atom, list(COMSIG_MOB_STATCHANGE, COMSIG_MOVABLE_SET_ANCHORED))

	grabbed_atom.cut_overlay(kinesis_icon)
	QDEL_NULL(kinesis_beam)

	if(isliving(grabbed_atom))
		grabbed_atom.remove_traits(list(TRAIT_IMMOBILIZED, TRAIT_HANDS_BLOCKED), REF(src))

	REMOVE_TRAIT(grabbed_atom, TRAIT_NO_FLOATING_ANIM, REF(src))

	if(!isitem(grabbed_atom))
		animate(grabbed_atom, 0.2 SECONDS, pixel_x = grabbed_atom.base_pixel_x, pixel_y = grabbed_atom.base_pixel_y)

	grabbed_atom = null

	STOP_PROCESSING(SSfastprocess, src)

	if(kinesis_catcher)
		var/mob/living/user = owner
		user?.clear_fullscreen("kinesis")
		kinesis_catcher = null


/datum/action/cooldown/spell/pointed/telekinesis/proc/on_statchange(mob/grabbed_mob, new_stat)
	SIGNAL_HANDLER
	if(new_stat < stat_required)
		clear_grab()

/datum/action/cooldown/spell/pointed/telekinesis/proc/on_setanchored(atom/movable/grabbed_atom_ref, anchorvalue)
	SIGNAL_HANDLER
	if(grabbed_atom_ref.anchored)
		clear_grab()
