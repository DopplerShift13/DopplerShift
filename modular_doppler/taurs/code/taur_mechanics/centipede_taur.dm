/obj/item/organ/taur_body/centipede
	left_leg_name = "dozens of left legs"
	right_leg_name = "dozens of right legs"

	clothing_cropping_state = NAGA_CLIPPING_MASK
	external_bodyshapes = parent_type::external_bodyshapes | BODYSHAPE_TAUR_SNAKE

	/// The skittering-along-the-ceiling ability we have given our owner. Nullable, if we have no owner.
	var/datum/action/cooldown/spell/centipede_perch/perch_ability

	/// Did our owner have their feet blocked before we ran on_mob_insert? Used for determining if we should unblock their feet slots on removal.
	var/owner_blocked_feet_before_insert

/obj/item/organ/taur_body/centipede/Destroy()
	QDEL_NULL(perch_ability) // handled in remove, but lets be safe
	return ..()

/obj/item/organ/taur_body/centipede/synth
	organ_flags = parent_type::organ_flags | ORGAN_ROBOTIC

/obj/item/organ/taur_body/centipede/on_mob_insert(mob/living/carbon/organ_owner, special, movement_flags)
	. = ..()

	// These args must be the same as the args used to add the basic human footstep!
	organ_owner.RemoveElement(/datum/element/footstep, FOOTSTEP_MOB_HUMAN, 1, -6)
	organ_owner.AddElement(/datum/element/footstep, FOOTSTEP_MOB_CENTIPEDE, 15, -6)

	perch_ability = new /datum/action/cooldown/spell/centipede_perch(organ_owner)
	perch_ability.Grant(organ_owner)

	owner_blocked_feet_before_insert = (organ_owner.dna.species.no_equip_flags & ITEM_SLOT_FEET)
	organ_owner.dna.species.no_equip_flags |= ITEM_SLOT_FEET
	organ_owner.dna.species.modsuit_slot_exceptions |= ITEM_SLOT_FEET

	var/obj/item/clothing/shoes/shoe = organ_owner.get_item_by_slot(ITEM_SLOT_FEET)
	if (shoe && !HAS_TRAIT(shoe, TRAIT_NODROP))
		shoe.forceMove(get_turf(organ_owner))

	add_hardened_soles(organ_owner)

/// Adds TRAIT_HARD_SOLES to our owner.
/obj/item/organ/taur_body/centipede/proc/add_hardened_soles(mob/living/carbon/organ_owner = owner)
	ADD_TRAIT(organ_owner, TRAIT_HARD_SOLES, ORGAN_TRAIT)

/obj/item/organ/taur_body/centipede/on_mob_remove(mob/living/carbon/organ_owner, special, movement_flags)
	. = ..()

	if (QDELETED(organ_owner)) return
	organ_owner.RemoveElement(/datum/element/footstep, FOOTSTEP_MOB_CENTIPEDE, 15, -6)
	organ_owner.AddElement(/datum/element/footstep, FOOTSTEP_MOB_HUMAN, 1, -6)

	QDEL_NULL(perch_ability)
	if (!owner_blocked_feet_before_insert)
		organ_owner.dna.species.no_equip_flags &= ~ITEM_SLOT_FEET
	owner_blocked_feet_before_insert = FALSE
	organ_owner.dna.species.modsuit_slot_exceptions &= ~ITEM_SLOT_FEET

	REMOVE_TRAIT(organ_owner, TRAIT_HARD_SOLES, ORGAN_TRAIT)

/datum/action/cooldown/spell/centipede_perch
	name = "Centipede Perch"
	desc = "Skitter along the ceiling!"
	button_icon_state = "negative"
	button_icon = 'icons/hud/screen_alert.dmi'
	cooldown_time = 1 SECONDS
	spell_requirements = NONE
	check_flags = AB_CHECK_CONSCIOUS|AB_CHECK_LYING|AB_CHECK_INCAPACITATED
	var/hangin = FALSE

/datum/action/cooldown/spell/centipede_perch/cast(mob/living/cast_on)
	. = ..()
	if(hangin)
		unflip(cast_on)
		return
	else if(check_above(cast_on))
		passtable_on(cast_on, REF(cast_on))
		cast_on.AddElement(/datum/element/forced_gravity, NEGATIVE_GRAVITY)
		owner.visible_message("<span class='notice'>[owner] raises up on [owner.p_their()] numerous legs, attaching to the ceiling!")
		hangin = TRUE

/datum/action/cooldown/spell/centipede_perch/proc/unflip(mob/living/flipper)
	passtable_off(flipper, REF(flipper))
	qdel(flipper.RemoveElement(/datum/element/forced_gravity, NEGATIVE_GRAVITY))
	UnregisterSignal(flipper, COMSIG_MOVABLE_MOVED)
	owner.visible_message("<span class='notice'>[owner] lowers [owner.p_their()] legs, returning to the ground!")
	hangin = FALSE

/datum/action/cooldown/spell/centipede_perch/proc/check_above(mob/living/target)
	var/turf/open/current_turf = get_turf(target)
	var/turf/open/openspace/turf_above = get_step_multiz(target, UP)
	if(current_turf && istype(turf_above))
		to_chat(target, span_warning("There's only open air above you, nothing to hang from!"))
		return FALSE
	return TRUE
