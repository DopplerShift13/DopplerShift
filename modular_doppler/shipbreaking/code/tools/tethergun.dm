#define TETHERGUN_MODE_MOVE "manipulate"
#define TETHERGUN_MODE_TETHER "tether"

// Someone on tg should really make kinesis a component or something instead of having to copy and paste all of it everywhere
/obj/item/tethergun
	name = "matter-energy tether spike"
	desc = "A complex tool developed for moving objects in microgravity environments at significant mass ratios \
		relative to the user. Such a tool has found use in all manner of orbital professions, from search and rescue to \
		shipbreaking. It features two primary functions, a manipulator for moving heavy objects, and a \"launch\" mode for \
		imparting force without an equal and opposite reaction on yourself."
	icon = 'modular_doppler/shipbreaking/icons/tools.dmi'
	icon_state = "tethergun"
	lefthand_file = 'modular_doppler/shipbreaking/icons/mob/lefthand.dmi'
	righthand_file = 'modular_doppler/shipbreaking/icons/mob/righthand.dmi'
	inhand_icon_state = "tethergun"
	worn_icon = 'modular_doppler/shipbreaking/icons/mob/worn.dmi'
	worn_icon_state = "tethergun"
	w_class = WEIGHT_CLASS_NORMAL
	resistance_flags = FIRE_PROOF
	item_flags = NOBLUDGEON
	drop_sound = 'sound/items/handling/tools/rcd_drop.ogg'
	pickup_sound = 'sound/items/handling/tools/rcd_pickup.ogg'
	sound_vary = TRUE
	slot_flags = ITEM_SLOT_BELT
	/// The current operating mode of the tethergun
	var/operating_mode = TETHERGUN_MODE_MOVE
	/// Range of the manipulator mode
	var/grab_range = 8
	/// Time between us hitting objects with manipulator mode
	var/hit_cooldown_time = 1 SECONDS
	/// Stat required for us to grab a mob
	var/stat_required = DEAD
	/// Atom we grabbed with manipulator mode
	var/atom/movable/grabbed_atom
	/// Ref of the beam following the grabbed atom.
	var/datum/beam/kinesis_beam
	/// Overlay we add to each grabbed atom.
	var/mutable_appearance/kinesis_icon
	/// Our mouse movement catcher
	var/atom/movable/screen/fullscreen/cursor_catcher/kinesis_catcher
	/// The sounds playing while we grabbed an object
	var/datum/looping_sound/gravgen/kinesis/soundloop
	/// The cooldown between us hitting objects with kinesis
	COOLDOWN_DECLARE(hit_cooldown)
	/// The length of the cooldown if an atom counts as "heavy"
	var/heavy_atom_delay = 1 SECONDS
	/// The cooldown between moving a grabbed thing between tiles
	COOLDOWN_DECLARE(atom_move_cooldown)
	/// The last mob that used this tethergun
	var/mob/living/last_user
	/// How long between right click launches do we wait
	var/rclick_launch_delay = 0.5 SECONDS
	/// Cooldown for launching things with rclick
	COOLDOWN_DECLARE(rclick_launch_cooldown)

/obj/item/tethergun/Initialize(mapload)
	. = ..()
	soundloop = new(src)

/obj/item/tethergun/Destroy()
	QDEL_NULL(soundloop)
	return ..()

/obj/item/tethergun/ranged_interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(!user.is_holding(src) || !user.client)
		return ITEM_INTERACT_BLOCKING
	if(grabbed_atom)
		clear_grab(playsound = FALSE)
		return ITEM_INTERACT_SUCCESS
	if(!range_check(interacting_with, user))
		balloon_alert(user, "too far!")
		return ITEM_INTERACT_BLOCKING
	if(!can_grab(interacting_with))
		balloon_alert(user, "can't grab!")
		return ITEM_INTERACT_BLOCKING
	switch(operating_mode)
		if(TETHERGUN_MODE_MOVE)
			grab_atom(interacting_with, user)
			return ITEM_INTERACT_SUCCESS

/obj/item/tethergun/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	return ranged_interact_with_atom(interacting_with, user, modifiers)

/obj/item/tethergun/ranged_interact_with_atom_secondary(atom/interacting_with, mob/living/user, list/modifiers)
	if(!user.is_holding(src) || !user.client)
		return ITEM_INTERACT_BLOCKING
	if(grabbed_atom)
		var/launched_object = grabbed_atom
		clear_grab(playsound = FALSE)
		launch(launched_object, user)
		return ITEM_INTERACT_SUCCESS
	if(!range_check(interacting_with, user))
		balloon_alert(user, "too far!")
		return ITEM_INTERACT_BLOCKING
	if(!can_grab(interacting_with))
		balloon_alert(user, "can't grab!")
		return ITEM_INTERACT_BLOCKING
	switch(operating_mode)
		if(TETHERGUN_MODE_MOVE)
			if(COOLDOWN_FINISHED(src, rclick_launch_cooldown))
				launch(interacting_with, user)
				COOLDOWN_START(src, rclick_launch_cooldown, rclick_launch_delay)
				return ITEM_INTERACT_SUCCESS

/obj/item/tethergun/interact_with_atom_secondary(atom/interacting_with, mob/living/user, list/modifiers)
	return ranged_interact_with_atom_secondary(interacting_with, user, modifiers)

/obj/item/tethergun/process(seconds_per_tick)
	var/mob/living/carbon/user
	if(iscarbon(loc))
		user = loc
	else
		clear_grab()
		return
	if(!user.client || INCAPACITATED_IGNORING(user, INCAPABLE_GRAB) || user != last_user || !user.is_holding(src))
		clear_grab()
		return
	if(!range_check(grabbed_atom, user))
		balloon_alert(user, "out of range!")
		clear_grab()
		return
	if(kinesis_catcher.mouse_params)
		kinesis_catcher.calculate_params()
	if(!kinesis_catcher.given_turf)
		return
	// user.setDir(get_dir(user, grabbed_atom))
	if(grabbed_atom.loc == kinesis_catcher.given_turf)
		if(grabbed_atom.pixel_x == kinesis_catcher.given_x - ICON_SIZE_X/2 && grabbed_atom.pixel_y == kinesis_catcher.given_y - ICON_SIZE_Y/2)
			return //spare us redrawing if we are standing still
		animate(grabbed_atom, 0.2 SECONDS, pixel_x = grabbed_atom.base_pixel_x + kinesis_catcher.given_x - ICON_SIZE_X/2, pixel_y = grabbed_atom.base_pixel_y + kinesis_catcher.given_y - ICON_SIZE_Y/2)
		kinesis_beam.redrawing()
		return
	animate(grabbed_atom, 0.2 SECONDS, pixel_x = grabbed_atom.base_pixel_x + kinesis_catcher.given_x - ICON_SIZE_X/2, pixel_y = grabbed_atom.base_pixel_y + kinesis_catcher.given_y - ICON_SIZE_Y/2)
	kinesis_beam.redrawing()
	var/turf/next_turf = get_step_towards(grabbed_atom, kinesis_catcher.given_turf)
	if(COOLDOWN_FINISHED(src, atom_move_cooldown))
		if(grabbed_atom.Move(next_turf, get_dir(grabbed_atom, next_turf), 8))
			var/apply_move_cooldown = TRUE
			if(isitem(grabbed_atom))
				var/obj/item/grabbed_item = grabbed_atom
				if(grabbed_item.w_class <= WEIGHT_CLASS_BULKY)
					apply_move_cooldown = FALSE
			if(apply_move_cooldown)
				COOLDOWN_START(src, atom_move_cooldown, heavy_atom_delay)
			if(isitem(grabbed_atom) && (user in next_turf))
				var/obj/item/grabbed_item = grabbed_atom
				clear_grab()
				grabbed_item.pickup(user)
				user.put_in_hands(grabbed_item)
			return
	var/pixel_x_change = 0
	var/pixel_y_change = 0
	var/direction = get_dir(grabbed_atom, next_turf)
	if(direction & NORTH)
		pixel_y_change = ICON_SIZE_Y/2
	else if(direction & SOUTH)
		pixel_y_change = -ICON_SIZE_Y/2
	if(direction & EAST)
		pixel_x_change = ICON_SIZE_X/2
	else if(direction & WEST)
		pixel_x_change = -ICON_SIZE_X/2
	animate(grabbed_atom, 0.2 SECONDS, pixel_x = grabbed_atom.base_pixel_x + pixel_x_change, pixel_y = grabbed_atom.base_pixel_y + pixel_y_change)
	kinesis_beam.redrawing()
	if(!isitem(grabbed_atom) || !COOLDOWN_FINISHED(src, hit_cooldown))
		return
	var/atom/hitting_atom
	if(next_turf.density)
		hitting_atom = next_turf
	for(var/atom/movable/movable_content as anything in next_turf.contents)
		if(ismob(movable_content))
			continue
		if(movable_content.density)
			hitting_atom = movable_content
			break
	var/obj/item/grabbed_item = grabbed_atom
	if(!isnull(hitting_atom))
		grabbed_item.melee_attack_chain(user, hitting_atom)
		COOLDOWN_START(src, hit_cooldown, hit_cooldown_time)

/// Checks if the target is something we are actually allowed to grab
/obj/item/tethergun/proc/can_grab(atom/target)
	if(loc == target)
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
		if(item_target.item_flags & ABSTRACT)
			return FALSE
	return TRUE

/// Grabs the target
/obj/item/tethergun/proc/grab_atom(atom/movable/target, mob/living/carbon/user)
	grabbed_atom = target
	last_user = user
	if(isliving(grabbed_atom))
		grabbed_atom.add_traits(list(TRAIT_IMMOBILIZED, TRAIT_HANDS_BLOCKED), REF(src))
		RegisterSignal(grabbed_atom, COMSIG_MOB_STATCHANGE, PROC_REF(on_statchange))
	ADD_TRAIT(grabbed_atom, TRAIT_NO_FLOATING_ANIM, REF(src))
	RegisterSignal(grabbed_atom, COMSIG_MOVABLE_SET_ANCHORED, PROC_REF(on_setanchored))
	playsound(grabbed_atom, 'sound/items/weapons/contractor_baton/contractorbatonhit.ogg', 75, TRUE)
	kinesis_icon = mutable_appearance(icon = 'icons/effects/effects.dmi', icon_state = "kinesis", layer = grabbed_atom.layer - 0.1, appearance_flags = RESET_ALPHA|RESET_COLOR|RESET_TRANSFORM|KEEP_APART)
	kinesis_icon.overlays += emissive_appearance(icon = 'icons/effects/effects.dmi', icon_state = "kinesis", offset_spokesman = grabbed_atom)
	grabbed_atom.add_overlay(kinesis_icon)
	kinesis_beam = user.Beam(grabbed_atom, "kinesis")
	kinesis_catcher = user.overlay_fullscreen("tethergun", /atom/movable/screen/fullscreen/cursor_catcher, 0)
	kinesis_catcher.assign_to_mob(user)
	RegisterSignal(kinesis_catcher, COMSIG_SCREEN_ELEMENT_CLICK, PROC_REF(on_catcher_click))
	soundloop.start()
	START_PROCESSING(SSfastprocess, src)

/// Lets go of whatever we are currently holding
/obj/item/tethergun/proc/clear_grab(playsound = TRUE)
	if(!grabbed_atom)
		return
	. = grabbed_atom
	if(playsound)
		playsound(grabbed_atom, 'sound/effects/empulse.ogg', 75, TRUE)
	STOP_PROCESSING(SSfastprocess, src)
	UnregisterSignal(grabbed_atom, list(COMSIG_MOB_STATCHANGE, COMSIG_MOVABLE_SET_ANCHORED))
	kinesis_catcher = null
	last_user.clear_fullscreen("tethergun")
	grabbed_atom.cut_overlay(kinesis_icon)
	QDEL_NULL(kinesis_beam)
	if(isliving(grabbed_atom))
		grabbed_atom.remove_traits(list(TRAIT_IMMOBILIZED, TRAIT_HANDS_BLOCKED), REF(src))
	REMOVE_TRAIT(grabbed_atom, TRAIT_NO_FLOATING_ANIM, REF(src))
	if(!isitem(grabbed_atom))
		animate(grabbed_atom, 0.2 SECONDS, pixel_x = grabbed_atom.base_pixel_x, pixel_y = grabbed_atom.base_pixel_y)
	grabbed_atom = null
	soundloop.stop()

/// Checks if the user and the target are within range of eachother and can be seen by the user
/obj/item/tethergun/proc/range_check(atom/target, mob/user)
	if(!isturf(user.loc))
		return FALSE
	if(ismovable(target) && !isturf(target.loc))
		return FALSE
	if(!can_see(user, target, grab_range))
		return FALSE
	return TRUE

/// Catches a right click from the user to release the grab
/obj/item/tethergun/proc/on_catcher_click(atom/source, location, control, params, user)
	SIGNAL_HANDLER
	var/list/modifiers = params2list(params)
	if(LAZYACCESS(modifiers, RIGHT_CLICK))
		clear_grab()

/// Checks a currently grabbed mob to see if they still fulfill requirements to be held by the tethergun
/obj/item/tethergun/proc/on_statchange(mob/grabbed_mob, new_stat)
	SIGNAL_HANDLER
	if(new_stat < stat_required)
		clear_grab()

/// Releases the held thing if it suddenly becomes anchored while we are holding it
/obj/item/tethergun/proc/on_setanchored(atom/movable/grabbed_atom, anchorvalue)
	SIGNAL_HANDLER
	if(grabbed_atom.anchored)
		clear_grab()

/// Launches the passed thing away from the user
/obj/item/tethergun/proc/launch(atom/movable/launched_object, mob/user)
	playsound(launched_object, 'sound/effects/magic/repulse.ogg', 100, TRUE)
	RegisterSignal(launched_object, COMSIG_MOVABLE_IMPACT, PROC_REF(launch_impact))
	var/turf/target_turf = get_turf_in_angle(get_angle(user, launched_object), get_turf(src), 10)
	launched_object.throw_at(target_turf, range = grab_range, speed = launched_object.density ? 3 : 4, thrower = user, spin = isitem(launched_object))

/// Handles an object thrown by the tethergun hitting something else
/obj/item/tethergun/proc/launch_impact(atom/movable/source, atom/hit_atom, datum/thrownthing/thrownthing)
	UnregisterSignal(source, COMSIG_MOVABLE_IMPACT)
	if(!(isstructure(source) || ismachinery(source) || isvehicle(source)))
		return
	var/damage_self = TRUE
	var/damage = 8
	if(source.density)
		damage_self = FALSE
		damage = 15
	if(isliving(hit_atom))
		var/mob/living/living_atom = hit_atom
		living_atom.apply_damage(damage, BRUTE)
	else if(hit_atom.uses_integrity)
		hit_atom.take_damage(damage, BRUTE, MELEE)
	if(damage_self && source.uses_integrity)
		source.take_damage(source.max_integrity/5, BRUTE, MELEE)
