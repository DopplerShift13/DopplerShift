/// How far a holosynth can stray from their projector pen
#define HOLOSYNTH_RANGE 9
#define HOLOSYNTH_MANUAL_HEAL_TIME 10 SECONDS
#define HOLOSYNTH_MANUAL_HEAL_BRUTE 50
#define HOLOSYNTH_MANUAL_HEAL_BURN 150

/obj/item/holosynth_pen
	name = "holosynth projector-magnet combo"
	desc = "A complex mechanism that both projects the form of a hologram and manipulates its aerogel canvas. \
	Miraculously, it also doubles as a pen."
	icon = 'modular_doppler/modular_species/species_types/android/holosynth/icons/holosynth_pen.dmi'
	worn_icon = 'modular_doppler/modular_species/species_types/android/holosynth/icons/holosynth_pen.dmi'
	icon_state = "Holopen"
	worn_icon_state = "w_holopen"
	slot_flags = ITEM_SLOT_BELT | ITEM_SLOT_EARS
	w_class = WEIGHT_CLASS_TINY
	var/colour = BLOOD_COLOR_HOLOGEL
	var/font = FOUNTAIN_PEN_FONT
	damtype = BURN
	force = 5

	///Weakref to the Mob this pen leashes and contains
	var/datum/weakref/linked_mob_ref
	///Weakref to the tile this pen saves to deploy the mob to and from
	var/datum/weakref/saved_loc_ref


/obj/item/holosynth_pen/Initialize(mapload, mob/living/carbon/human/linked_mob)
	. = ..()
	AddElement(/datum/element/tool_renaming)

	if(linked_mob)
		linked_mob_ref = WEAKREF(linked_mob)
		saved_loc_ref = WEAKREF(get_turf(linked_mob))

		create_transform_component()
		RegisterSignal(src, COMSIG_TRANSFORMING_PRE_TRANSFORM, PROC_REF(transform_check))
		RegisterSignal(src, COMSIG_TRANSFORMING_ON_TRANSFORM, PROC_REF(on_transform))

		linked_mob.AddComponent(\
			/datum/component/leash,\
			owner = src,\
			distance = HOLOSYNTH_RANGE,\
			force_teleport_out_effect = /obj/effect/temp_visual/guardian/phase/out,\
			force_teleport_in_effect = /obj/effect/temp_visual/guardian/phase,\
		)

	else
		linked_mob_ref = null

	AddComponent( \
		/datum/component/aura_healing, \
		range = 1, \
		brute_heal = 1, \
		burn_heal = 1.5, \
		blood_heal = 2, \
		simple_heal = 1.2, \
		wound_clotting = 0.1, \
		organ_healing = list(ORGAN_SLOT_BRAIN = 1, ORGAN_SLOT_HEART = 0.5, ORGAN_SLOT_EARS = 1, ORGAN_SLOT_EYES = 1, ORGAN_SLOT_TONGUE = 1.5), \
		requires_visibility = FALSE, \
		limit_to_trait = TRAIT_HOLOSYNTH, \
		healing_color = BLOOD_COLOR_HOLOGEL, \
	)

/obj/item/holosynth_pen/proc/create_transform_component()
	AddComponent( \
		/datum/component/transforming, \
		start_transformed = FALSE, \
		force_on = 14, \
		inhand_icon_change = FALSE, \
		w_class_on = w_class, \
	)

/obj/item/holosynth_pen/proc/on_transform(obj/item/source, mob/user, active)
	SIGNAL_HANDLER

	if(user)
		balloon_alert(user, "clicked")
	playsound(src, 'sound/items/pen_click.ogg', 30, TRUE, -3)
	icon_state = initial(icon_state) + (active ? "_writing" : "")
	worn_icon_state = initial(worn_icon_state) + (active ? "_writing" : "")
	update_appearance(UPDATE_ICON)

	var/mob/living/carbon/human/linked_mob = linked_mob_ref?.resolve()
	var/turf/saved_loc = saved_loc_ref?.resolve()

	if(isnull(linked_mob))
		return COMPONENT_NO_DEFAULT_MESSAGE

	if(active) //If you WERE active we save loc and place our creature into pen
		saved_loc_ref = WEAKREF(get_turf(linked_mob))
		new /obj/effect/temp_visual/guardian/phase/out (get_turf(linked_mob))
		linked_mob.unequip_everything()
		linked_mob.forceMove(src)
		linked_mob.add_traits(list(TRAIT_INCAPACITATED, TRAIT_IMMOBILIZED, TRAIT_HANDS_BLOCKED), "Pen Prison")

	else	//Otherwise, put the hologram back
		linked_mob.remove_traits(list(TRAIT_INCAPACITATED, TRAIT_IMMOBILIZED, TRAIT_HANDS_BLOCKED), "Pen Prison")
		if(get_dist(saved_loc, src) <= HOLOSYNTH_RANGE)
			linked_mob.forceMove(saved_loc)
			new /obj/effect/temp_visual/guardian/phase (get_turf(linked_mob))
		else
			balloon_alert(user, "too far!")
			linked_mob.forceMove(get_turf(src)) //If we're too far, teleport to the pen as a fall back and save the new location
			new /obj/effect/temp_visual/guardian/phase (get_turf(src))
			saved_loc_ref = WEAKREF(get_turf(linked_mob))

	return COMPONENT_NO_DEFAULT_MESSAGE

/obj/item/holosynth_pen/Destroy()
	var/mob/living/carbon/human/linked_mob = linked_mob_ref?.resolve()

	if(linked_mob)
		linked_mob.apply_status_effect(/datum/status_effect/holosynth_dissolving)
		linked_mob.visible_message(
			span_danger("[linked_mob]'s whole body begins to flicker, shudder and fall apart!"),
 			span_userdanger("You feel your projector being destroyed! Your form loses cohesion!")
		)
	. = ..()

/obj/item/holosynth_pen/ranged_interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)

	var/mob/living/carbon/human/linked_mob = linked_mob_ref?.resolve()

	if(isnull(linked_mob))
		return ITEM_INTERACT_FAILURE
	if(user == linked_mob)
		return ITEM_INTERACT_FAILURE
	if(linked_mob.loc != src)
		balloon_alert(user, "holosynth is active!")
		return ITEM_INTERACT_FAILURE
	if(interacting_with.density)
		balloon_alert(user, "solid object!")
		return ITEM_INTERACT_FAILURE

	saved_loc_ref = WEAKREF(get_turf(interacting_with))
	balloon_alert(user, "location targeted")
	playsound(src, 'sound/items/pen_click.ogg', 30, TRUE, -3)
	return ITEM_INTERACT_SUCCESS

/obj/item/holosynth_pen/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	var/turf/interacting_turf = interacting_with
	var/mob/living/carbon/human/linked_mob = linked_mob_ref?.resolve()

	if(istype(interacting_turf))
		if(isnull(linked_mob))
			return ITEM_INTERACT_FAILURE
		if(user == linked_mob)
			return ITEM_INTERACT_FAILURE
		if(linked_mob.loc != src)
			balloon_alert(user, "holosynth is active!")
			return ITEM_INTERACT_FAILURE
		if(interacting_with.density)
			balloon_alert(user, "solid object!")
			return ITEM_INTERACT_FAILURE

		saved_loc_ref = WEAKREF(get_turf(interacting_with))
		balloon_alert(user, "location targeted")
		playsound(src, 'sound/items/pen_click.ogg', 30, TRUE, -3)
		return ITEM_INTERACT_SUCCESS

	else return NONE

/obj/item/holosynth_pen/examine(mob/user)
	. = ..()
	var/mob/living/carbon/human/linked_mob = linked_mob_ref?.resolve()

	if(linked_mob)
		. += span_info("This one belongs to [linked_mob].")

/obj/item/holosynth_pen/get_writing_implement_details()
	if (HAS_TRAIT(src, TRAIT_TRANSFORM_ACTIVE))
		return list(
		interaction_mode = MODE_WRITING,
		font = font,
		color = colour,
		use_bold = FALSE,
		)
	else
		return null

/obj/item/holosynth_pen/proc/transform_check(obj/item/source, mob/user, active)
	SIGNAL_HANDLER

	var/mob/living/carbon/human/linked_mob = linked_mob_ref?.resolve()
	if(user == linked_mob)
		balloon_alert(user, "can't modify yourself!")
		return COMPONENT_BLOCK_TRANSFORM

//Manual Healing
/obj/item/holosynth_pen/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)

	if(istype(interacting_with, /mob/living))
		return manual_heal(interacting_with, user)

/obj/item/holosynth_pen/proc/manual_heal(mob/living/target_mob, mob/living/healer)
	var/linked_mob = linked_mob_ref?.resolve()

	if(linked_mob == healer) //No Self Healing
		return ITEM_INTERACT_SKIP_TO_ATTACK

	if(target_mob == linked_mob && healer.combat_mode == FALSE)
		healer.visible_message("[healer] carefully shines the projector over [linked_mob]'s wounds. Whispy bands of light and aerogel delicately float over to replace what was damaged.")

		target_mob.add_filter("holo_heal", 2, list("type" = "outline", "color" = COLOR_HEALING_CYAN, "size" = 1))
		addtimer(CALLBACK(target_mob, TYPE_PROC_REF(/datum, remove_filter), "holo_heal"), HOLOSYNTH_MANUAL_HEAL_TIME)

		if(!do_after(healer, HOLOSYNTH_MANUAL_HEAL_TIME, target_mob))
			target_mob.remove_filter("holo_heal")
			return ITEM_INTERACT_FAILURE

		target_mob.adjustBruteLoss(-1 * HOLOSYNTH_MANUAL_HEAL_BRUTE, updating_health = TRUE)
		target_mob.adjustFireLoss(-1 * HOLOSYNTH_MANUAL_HEAL_BURN, updating_health = TRUE)
		return ITEM_INTERACT_SUCCESS

	else
		return ITEM_INTERACT_SKIP_TO_ATTACK

/// the DEATH effect
/atom/movable/screen/alert/status_effect/holosynth_death_alert
	name = "Projector Destroyed"
	desc = "YOUR FORM COLLAPSES AT THE SEAMS, you are MELTING AWAY!!"
	icon_state = "convulsing"

/datum/status_effect/holosynth_dissolving
	id = "holo_dissolve"
	remove_on_fullheal = FALSE
	duration = 30 SECONDS
	show_duration = TRUE
	alert_type = /atom/movable/screen/alert/status_effect/holosynth_death_alert

/datum/status_effect/holosynth_dissolving/tick()
	do_sparks(rand(2,6), FALSE, owner)

/datum/status_effect/holosynth_dissolving/on_remove()
	owner.gib(DROP_ALL_REMAINS & ~DROP_BODYPARTS) //bright side, your brain's in there. Someone'll use it I'm sure.

#undef HOLOSYNTH_RANGE
#undef HOLOSYNTH_MANUAL_HEAL_TIME
#undef HOLOSYNTH_MANUAL_HEAL_BRUTE
#undef HOLOSYNTH_MANUAL_HEAL_BURN
