/*
	Mends damaged and destroyed psyker organs through the power of unstable mutagen. A lil bit toxic.
	Basically organ manipulation steps with unstable mutagen substituting organ manip.
*/
/datum/surgery/psyker_organ_repair
	name = "Mend Psychic Organ"
	desc = "Attempts to restore functionality to a damaged or destroyed Psyker's organ. Requires 5u of unstable mutagen."
	surgery_flags = SURGERY_REQUIRE_RESTING | SURGERY_REQUIRE_LIMB | SURGERY_REQUIRES_REAL_LIMB
	organ_to_manipulate = ORGAN_SLOT_PSYKER

	possible_locs = list(
		BODY_ZONE_CHEST
	)
	steps = list(
		/datum/surgery_step/incise,
		/datum/surgery_step/retract_skin,
		/datum/surgery_step/saw,
		/datum/surgery_step/clamp_bleeders,
		/datum/surgery_step/incise,
		/datum/surgery_step/apply_unstable_mutagen_to_psyker_organ,
		/datum/surgery_step/close,
	)

/datum/surgery/psyker_organ_repair/can_start(mob/user, mob/living/carbon/target)
	. = ..()
	if(!.)
		return .

	var/obj/item/organ/resonant/psyker/psyker_organ = target.get_organ_slot(ORGAN_SLOT_PSYKER)
	if(!psyker_organ)
		return FALSE

	return psyker_organ.damage > 0

/datum/surgery_step/apply_unstable_mutagen_to_psyker_organ
	name = "apply 5u of unstable mutagen to psyker organ (reagent container)"
	implements = list(
		/obj/item/reagent_containers = 100,
	)
	time = 6.4 SECONDS
	preop_sound = 'sound/items/handling/surgery/hemostat1.ogg'
	success_sound = 'sound/items/drink.ogg'
	failure_sound = 'sound/items/drink.ogg'
	surgery_effects_mood = TRUE

/datum/surgery_step/apply_unstable_mutagen_to_psyker_organ/tool_check(mob/user, obj/item/tool)
	return tool.reagents?.has_reagent(/datum/reagent/toxin/mutagen, 5)

/datum/surgery_step/apply_unstable_mutagen_to_psyker_organ/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(
		user,
		target,
		span_notice("You begin to bathe [target]'s psyker organ in unstable mutagen..."),
		span_notice("[user] begins applying unstable mutagen to [target]'s exposed psyker organ."),
		span_notice("[user] begins treating something deep inside [target]'s chest."),
	)
	display_pain(target, "You feel something swell and push against your organs!")

/datum/surgery_step/apply_unstable_mutagen_to_psyker_organ/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	var/obj/item/organ/resonant/psyker/psyker_organ = target.get_organ_slot(ORGAN_SLOT_PSYKER)
	if(!psyker_organ)
		to_chat(user, span_warning("[target] no longer has a psyker organ to repair!"))
		return FALSE

	if(!tool.reagents?.remove_reagent(/datum/reagent/toxin/mutagen, 5))
		to_chat(user, span_warning("[tool] does not have enough unstable mutagen left!"))
		return FALSE

	psyker_organ.apply_organ_damage(-psyker_organ.damage, psyker_organ.maxHealth)
	target.apply_damage(10, TOX)

	display_results(
		user,
		target,
		span_notice("You restore [target]'s psyker organ with the mutagen treatment."),
		span_notice("[user] restores [target]'s psyker organ with a measured mutagen treatment."),
		span_notice("[user] finishes treating an exposed organ in [target]'s chest."),
	)
	display_pain(target, "A sharp pain spikes in your chest, before receeding into nothingness.")
	return ..()

/datum/surgery_step/apply_unstable_mutagen_to_psyker_organ/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, fail_prob = 0)
	var/obj/item/organ/resonant/psyker/psyker_organ = target.get_organ_slot(ORGAN_SLOT_PSYKER)
	if(psyker_organ)
		psyker_organ.apply_organ_damage(10)

	var/list/chest_organs = target.get_organs_for_zone(BODY_ZONE_CHEST)
	for(var/obj/item/organ/chest_organ as anything in chest_organs)
		if(chest_organ == psyker_organ)
			continue
		chest_organ.apply_organ_damage(rand(1, 30))

	target.apply_damage(25, TOX)

	tool.reagents?.trans_to(target, 5, target_id = /datum/reagent/toxin/mutagen, transferred_by = user, methods = INJECT)

	display_results(
		user,
		target,
		span_warning("You misapply the mutagen, causing [target]'s chest organs to twist and mutate!"),
		span_warning("[user] misapplies the mutagen, causing [target]'s chest organs to twist and mutate!"),
		span_warning("[user] botches a delicate treatment inside [target]'s chest!"),
	)
	display_pain(target, "You feel your organs writhe and mutate inside your chest!")
	return FALSE
