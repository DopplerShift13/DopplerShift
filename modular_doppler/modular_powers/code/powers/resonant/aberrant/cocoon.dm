// Put things into a bundle of webs. Mostly on-demand storage and sorting; or dealing with people you don't want to escape.
/datum/power/aberrant/cocoon
	name = "Cocoon"
	desc = "Allows you to cocoon objects and people after a delay. You can destroy cocoons by interacting with them.\
	\n Targeting a space without a creature bundles all items on that space up in a container; this has the size and storage capacity of about two backpacks, and can only be opened by destroying it.\
	\n Targeting a prone creature that you have aggressively grabbed bundles them up. The creature is buckled inside the cocoon and can't interact with the world or escape without struggling. \
	Creature cocoons can be dragged around with less slow down commpared to normal."
	value = 3

	required_powers = list(/datum/power/aberrant/web_crafter)
	action_path = /datum/action/cooldown/power/aberrant/cocoon

/datum/action/cooldown/power/aberrant/cocoon
	name = "Cocoon"
	desc = "Wraps up a person or object for convenient storage. Object cocoons can be carried around and allow you to carry greater amount of items with relative ease. People cocoons can be used to keep people from escaping."
	button_icon = 'icons/effects/web.dmi'
	button_icon_state = "cocoon_large1"
	cooldown_time = 2

	target_range = 1
	target_self = FALSE // why would you
	click_to_activate = TRUE
	use_time = 5 SECONDS

/datum/action/cooldown/power/aberrant/cocoon/InterceptClickOn(mob/living/clicker, params, atom/target)
	..()
	// Always consume the click to avoid normal click interactions.
	return TRUE

/datum/action/cooldown/power/aberrant/cocoon/use_action(mob/living/user, atom/target)
	var/atom/resolved_target = resolve_cocoon_target(target)
	// Living targets get wrapped.
	if(isliving(resolved_target))
		if(!can_cocoon_mob(user, resolved_target))
			return FALSE
		return cocoon_mob(user, resolved_target)
	// Because misclicking will also start a progress bar, it can kinda suck to realize you're cocooning the wrong thing. A soft auto-aim where if therés a mob on the turf, it always has presedence.
	var/turf/target_turf = get_turf(target)
	if(target_turf)
		for(var/mob/living/occupant in target_turf)
			return cocoon_mob(user, occupant)
	// Cocoon objects in the space if we don't have other targets.
	return cocoon_object(user, target)

// Both cast time and visual effects are resolved into that.
/datum/action/cooldown/power/aberrant/cocoon/do_use_time(mob/living/user, atom/target)
	// Woooow I worked hard on this and you just var-edit it away BAKA.
	if(use_time <= 0)
		return TRUE
	var/atom/use_target = resolve_cocoon_target(target)
	if(!use_target)
		return FALSE
	var/turf/target_turf = get_turf(use_target)
	if(!target_turf)
		return do_after(user, use_time, target = use_target, timed_action_flags = use_time_flags)
	playsound(user, 'sound/items/handling/surgery/organ1.ogg', 50, TRUE, MEDIUM_RANGE_SOUND_EXTRARANGE)
	// Applies a visual effect similar to chiseling away at stone
	var/obj/effect/temp_visual/cocoon_progress/progress_visual = new /obj/effect/temp_visual/cocoon_progress(target_turf)
	progress_visual.apply_cocoon_appearance(use_target)
	progress_visual.pixel_x = use_target.pixel_x
	progress_visual.pixel_y = use_target.pixel_y
	// If we having a living target, we assing it here.
	var/mob/living/target_mob
	if(isliving(use_target))
		target_mob = use_target
		// Align the sprite with the animation
		target_mob.set_lying_angle(LYING_ANGLE_EAST)
		progress_visual.setDir(EAST)
	else
		progress_visual.setDir(use_target.dir)
	progress_visual.set_completion(0)

	// spin!
	if(target_mob)
		target_mob.spin(spintime = use_time, speed = 2)

	// Do_after loop and a progress bar for the user.
	var/datum/progressbar/total_progress_bar = new(user, use_time, use_target)
	var/use_time_period = max(1, round(use_time / ICON_SIZE_Y))
	var/remaining_time = use_time
	var/interrupted = FALSE
	if(target_mob)
		target_mob.remove_filter("cocoon_hide") // removes existing filter if its there.
	while(remaining_time > 0 && !interrupted)
		if(target_mob && !can_cocoon_mob(user, use_target))
			interrupted = TRUE
			break
		// We update the progress bar as well as the visual effects for the cocoon.
		if(do_after(user, use_time_period, target = use_target, timed_action_flags = use_time_flags, progress = FALSE))
			remaining_time -= use_time_period
			total_progress_bar.update(use_time - remaining_time)
			var/progress = (use_time - remaining_time) / use_time
			progress_visual.set_completion(progress) // this line's responsible for the cocoon effect
			// this filter keeps pace with the cocoon and hides the mob so it doesn't have 'bits' poking out.
			if(target_mob)
				var/mask_offset = min(ICON_SIZE_Y, round(progress * ICON_SIZE_Y))
				target_mob.add_filter("cocoon_hide", 1, alpha_mask_filter(icon = icon('icons/effects/alphacolors.dmi', "white"), y = mask_offset))
		else
			interrupted = TRUE
	total_progress_bar.end_progress()

	if(!QDELETED(progress_visual))
		qdel(progress_visual)
	if(target_mob)
		target_mob.remove_filter("cocoon_hide")
	return !interrupted

// Because misclicking will also start a progress bar, it can kinda suck to realize you're cocooning the wrong thing. A soft auto-aim where if there's a mob on the turf, it always has presedence.
/datum/action/cooldown/power/aberrant/cocoon/proc/resolve_cocoon_target(atom/target)
	if(isliving(target))
		return target
	var/turf/target_turf = get_turf(target)
	if(target_turf)
		for(var/mob/living/occupant in target_turf)
			return occupant
	return target

/datum/action/cooldown/power/aberrant/cocoon/proc/cocoon_mob(mob/living/user, mob/living/target)
	if(!target || QDELETED(target))
		return FALSE
	var/turf/target_turf = get_turf(target)
	if(!target_turf)
		return FALSE

	var/obj/structure/closet/body_bag/cocoon/new_cocoon = new /obj/structure/closet/body_bag/cocoon(target_turf)
	if(!new_cocoon)
		return FALSE
	if(!new_cocoon.insert(target))
		qdel(new_cocoon)
		return FALSE
	return TRUE

/datum/action/cooldown/power/aberrant/cocoon/proc/can_cocoon_mob(mob/living/user, mob/living/target)
	if(!user || !target)
		user.balloon_alert(user, "No target!")
		return FALSE
	if(QDELETED(user) || QDELETED(target))
		user.balloon_alert(user, "No target!")
		return FALSE
	if(user.pulling != target || user.grab_state < GRAB_AGGRESSIVE)
		user.balloon_alert(user, "You must aggressively grab the target!")
		return FALSE
	if(target.body_position != LYING_DOWN)
		user.balloon_alert(user, "Target must be prone!")
		return FALSE
	return TRUE

// We get the space we're on and bundle up all the items on the space; as much as possible.
/datum/action/cooldown/power/aberrant/cocoon/proc/cocoon_object(mob/living/user, atom/target)
	var/turf/target_turf = get_turf(target)
	if(!target_turf)
		return FALSE

	var/obj/item/storage/cocoon_item/new_cocoon = new /obj/item/storage/cocoon_item(target_turf)
	if(!new_cocoon?.atom_storage)
		qdel(new_cocoon)
		return FALSE

	// Stuffs everything inside of the container
	var/inserted_any = FALSE
	var/previous_lock_state = new_cocoon.atom_storage.locked
	new_cocoon.atom_storage.set_locked(STORAGE_NOT_LOCKED)
	for(var/obj/item/thing in target_turf)
		if(thing == new_cocoon || thing.anchored)
			continue
		if(new_cocoon.atom_storage.attempt_insert(thing, null, messages = FALSE))
			inserted_any = TRUE
	new_cocoon.atom_storage.set_locked(previous_lock_state)

	// can't make empty ones
	if(!inserted_any)
		user.balloon_alert(user, "Nothing to wrap!")
		qdel(new_cocoon)
		return FALSE
	return TRUE

// Cocoon for items
/obj/item/storage/cocoon_item
	name = "cocoon"
	desc = "A tight bundle of webbing packed with stored goods. You will have to tear it open to get anything out."
	icon = 'icons/effects/web.dmi'
	icon_state = "cocoon1"
	w_class = WEIGHT_CLASS_BULKY
	var/unwrap_delay = 4 SECONDS

/obj/item/storage/cocoon_item/Initialize(mapload)
	. = ..()
	if(atom_storage)
		atom_storage.max_slots = 30
		atom_storage.max_total_storage = 35
		atom_storage.attack_hand_interact = FALSE
		atom_storage.click_alt_open = FALSE
		atom_storage.display_contents = FALSE
		atom_storage.insert_on_attack = FALSE
		atom_storage.set_locked(STORAGE_FULLY_LOCKED)

/obj/item/storage/cocoon_item/attack_self(mob/user, modifiers)
	return attempt_unwrap(user)

/obj/item/storage/cocoon_item/proc/attempt_unwrap(mob/living/user)
	if(!user)
		return FALSE
	to_chat(user, span_notice("You start tearing open [src]..."))
	if(!do_after(user, unwrap_delay, target = src))
		return FALSE
	if(QDELETED(src))
		return FALSE
	var/turf/drop_turf = get_turf(src)
	if(atom_storage && drop_turf)
		atom_storage.remove_all(drop_turf)
	visible_message(span_notice("[src] is torn open, spilling its contents!"))
	qdel(src)
	return TRUE

// Cocoon for people
/obj/structure/closet/body_bag/cocoon
	name = "cocoon"
	desc = "A person-sized cocoon; rows upon rows of silk keeping something quite secure."
	icon = 'icons/effects/web.dmi'
	icon_state = "cocoon_large1"
	max_integrity = 40
	material_drop = null
	material_drop_amount = 0
	obj_flags = CAN_BE_HIT
	breakout_time = 2 MINUTES
	mob_storage_capacity = 1
	drag_slowdown = 0.5
	var/open_time = 5 SECONDS

/obj/structure/closet/body_bag/cocoon/can_open(mob/living/user, force = FALSE)
	return FALSE

/obj/structure/closet/body_bag/cocoon/can_close(mob/living/user)
	return FALSE

/obj/structure/closet/body_bag/cocoon/toggle(mob/living/user)
	return FALSE

/obj/structure/closet/body_bag/cocoon/attack_hand(mob/living/user, list/modifiers)
	tear_open(user)

/obj/structure/closet/body_bag/cocoon/attack_hand_secondary(mob/user, list/modifiers)
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/structure/closet/body_bag/cocoon/attempt_fold(mob/living/carbon/human/the_folder)
	return FALSE

/obj/structure/closet/body_bag/cocoon/container_resist_act(mob/living/user, loc_required = TRUE)
	var/breakout_time = 2 MINUTES
	user.changeNext_move(CLICK_CD_BREAKOUT)
	user.last_special = world.time + CLICK_CD_BREAKOUT
	to_chat(user, span_notice("You struggle against the webs... (This will take about [DisplayTimeText(breakout_time)].)"))
	visible_message(span_notice("You see something struggling and writhing in \the [src]!"))
	if(do_after(user, breakout_time, target = src))
		if(user.stat != CONSCIOUS || user.loc != src)
			return
		qdel(src)

/obj/structure/closet/body_bag/cocoon/proc/tear_open(mob/living/user)
	if(open_time > 0)
		to_chat(user, span_notice("You start tearing open [src]..."))
		if(!do_after(user, open_time, target = src))
			return
	if(QDELETED(src))
		return
	var/turf/drop_turf = get_turf(src)
	if(drop_turf)
		for(var/atom/movable/thing as anything in contents)
			thing.forceMove(drop_turf)
	visible_message(span_notice("[src] is torn open, spilling its contents!"))
	qdel(src)

// Cocoon progress visual for use_time.
/obj/effect/temp_visual/cocoon_progress
	icon = 'icons/effects/web.dmi'
	icon_state = "cocoon_large1"
	randomdir = FALSE
	layer = ABOVE_MOB_LAYER
	appearance_flags = KEEP_TOGETHER | KEEP_APART
	duration = 1 MINUTES
	var/completion = 0

// Takes the icon and state from the associated cocoon
/obj/effect/temp_visual/cocoon_progress/proc/apply_cocoon_appearance(atom/target)
	if(isliving(target))
		var/obj/structure/closet/body_bag/cocoon/reference = /obj/structure/closet/body_bag/cocoon
		icon = initial(reference.icon)
		icon_state = initial(reference.icon_state)
	else
		var/obj/item/storage/cocoon_item/reference = /obj/item/storage/cocoon_item
		icon = initial(reference.icon)
		icon_state = initial(reference.icon_state)

/obj/effect/temp_visual/cocoon_progress/proc/set_completion(value)
	completion = clamp(value, 0, 1)
	var/static/icon/white = icon('icons/effects/alphacolors.dmi', "white")
	switch(completion)
		if(0)
			alpha = 0
			remove_filter("partial_uncover")
			filters = null
		else
			alpha = 255
			var/mask_offset = min(ICON_SIZE_X, round(completion * ICON_SIZE_X))
			remove_filter("partial_uncover")
			add_filter("partial_uncover", 1, alpha_mask_filter(icon = white, x = mask_offset, flags = MASK_INVERSE))
