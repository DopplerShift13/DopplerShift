// Custom steps for premium augment maintenance surgery.

// Surgery step: open access panel before servicing.
/datum/surgery_step/premium_augment_access
	name = "open maintenance panel (screwdriver)"
	implements = list(
		TOOL_SCREWDRIVER = 100,
		TOOL_SCALPEL = 75,
		/obj/item/knife = 50,
		/obj/item = 10) // 10% success with any sharp item.
	time = 2.6 SECONDS
	preop_sound = 'sound/items/tools/screwdriver.ogg'
	success_sound = 'sound/items/tools/screwdriver2.ogg'
	surgery_effects_mood = TRUE

/// Gets the premium augments that exist in the selected zone.
/datum/surgery_step/premium_augment_access/proc/get_premium_augments_for_zone(mob/living/carbon/target, target_zone)
	if(!target)
		return null
	var/list/organs = target.get_organs_for_zone(target_zone)
	var/list/premium_augments = list()
	for(var/obj/item/organ/organ as anything in organs)
		if(organ.premium)
			premium_augments += organ
	return premium_augments

/datum/surgery_step/premium_augment_access/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	var/obj/item/organ/target_implant
	var/datum/surgery/premium_augment_maintenance/premium_surgery = surgery
	if(istype(premium_surgery))
		target_implant = premium_surgery.get_selected_premium(user, target, target_zone, tool)
	else
		var/list/premium_augments = get_premium_augments_for_zone(target, target_zone)
		if(LAZYLEN(premium_augments) == 1)
			target_implant = premium_augments[1]

	if(!target_implant)
		if(target_zone == BODY_ZONE_PRECISE_EYES || target_zone == BODY_ZONE_PRECISE_MOUTH)
			target_zone = check_zone(target_zone)
		to_chat(user, span_warning("You can't find any premium augments to access in [target]'s [target.parse_zone_with_bodypart(target_zone)]."))
		return SURGERY_STEP_FAIL

	if(target_zone == BODY_ZONE_PRECISE_EYES || target_zone == BODY_ZONE_PRECISE_MOUTH)
		target_zone = check_zone(target_zone)
	display_results(
		user,
		target,
		span_notice("You begin opening the access panel to [target]'s [target_implant.name] in [target.parse_zone_with_bodypart(target_zone)]..."),
		span_notice("[user] begins opening an access panel in [target]'s [target.parse_zone_with_bodypart(target_zone)]."),
		span_notice("[user] begins opening something inside [target]'s [target.parse_zone_with_bodypart(target_zone)]."),
	)
	display_pain(target, "You feel a sharp, uncomfortable pressure in your [target.parse_zone_with_bodypart(target_zone)]!")

/datum/surgery_step/premium_augment_access/success(mob/living/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	var/obj/item/organ/target_implant
	var/datum/surgery/premium_augment_maintenance/premium_surgery = surgery
	if(istype(premium_surgery))
		target_implant = premium_surgery.selected_premium
	if(!target_implant || target_implant.owner != target || !target_implant.premium || target_implant.zone != target_zone)
		target_implant = null
	if(!target_implant)
		to_chat(user, span_warning("[target] has no premium augments there to access!"))
		return ..()

	if(target_zone == BODY_ZONE_PRECISE_EYES || target_zone == BODY_ZONE_PRECISE_MOUTH)
		target_zone = check_zone(target_zone)
	display_results(
		user,
		target,
		span_notice("You open access to [target]'s [target_implant.name] in [target.parse_zone_with_bodypart(target_zone)]."),
		span_notice("[user] opens access to premium augment hardware in [target]'s [target.parse_zone_with_bodypart(target_zone)]."),
		span_notice("[user] opens access to something inside [target]'s [target.parse_zone_with_bodypart(target_zone)]."),
	)
	return ..()

// Surgery step: perform the actual maintenance.
/datum/surgery_step/premium_augment_maintenance
	name = "service premium augment (multitool)"
	implements = list(
		TOOL_MULTITOOL = 100,
		TOOL_WIRECUTTER = 65,
	)
	time = 4 SECONDS
	preop_sound = 'sound/items/tools/ratchet.ogg'
	success_sound = 'sound/machines/airlock/doorclick.ogg'
	surgery_effects_mood = TRUE

/// Yes you aren't seeing double. Gets the premium augments in the selected zone. They're two seperate surgries.
/datum/surgery_step/premium_augment_maintenance/proc/get_premium_augments_for_zone(mob/living/carbon/target, target_zone)
	if(!target)
		return null
	var/list/organs = target.get_organs_for_zone(target_zone)
	var/list/premium_augments = list()
	for(var/obj/item/organ/organ as anything in organs)
		if(organ.premium)
			premium_augments += organ
	return premium_augments

/datum/surgery_step/premium_augment_maintenance/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	var/obj/item/organ/target_implant
	var/datum/surgery/premium_augment_maintenance/premium_surgery = surgery
	if(istype(premium_surgery))
		target_implant = premium_surgery.get_selected_premium(user, target, target_zone, tool)
	else
		var/list/premium_augments = get_premium_augments_for_zone(target, target_zone)
		if(LAZYLEN(premium_augments) == 1)
			target_implant = premium_augments[1]

	if(!target_implant)
		if(target_zone == BODY_ZONE_PRECISE_EYES || target_zone == BODY_ZONE_PRECISE_MOUTH)
			target_zone = check_zone(target_zone)
		to_chat(user, span_warning("You can't find any premium augments to service in [target]'s [target.parse_zone_with_bodypart(target_zone)]."))
		return SURGERY_STEP_FAIL
	if(target_implant.premium_component && target_implant.premium_component.quality <= 0)
		if(target_zone == BODY_ZONE_PRECISE_EYES || target_zone == BODY_ZONE_PRECISE_MOUTH)
			target_zone = check_zone(target_zone)
		to_chat(user, span_warning("[target]'s [target_implant.name] in [target.parse_zone_with_bodypart(target_zone)] is broken and needs refurbishing first."))
		return SURGERY_STEP_FAIL

	if(target_zone == BODY_ZONE_PRECISE_EYES || target_zone == BODY_ZONE_PRECISE_MOUTH)
		target_zone = check_zone(target_zone)
	display_results(
		user,
		target,
		span_notice("You begin servicing [target]'s [target_implant.name] in [target.parse_zone_with_bodypart(target_zone)]..."),
		span_notice("[user] begins servicing the premium augment hardware in [target]'s [target.parse_zone_with_bodypart(target_zone)]."),
		span_notice("[user] begins servicing something inside [target]'s [target.parse_zone_with_bodypart(target_zone)]."),
	)
	display_pain(target, "You feel a sharp, uncomfortable pressure in your [target.parse_zone_with_bodypart(target_zone)]!")

/datum/surgery_step/premium_augment_maintenance/success(mob/living/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	var/obj/item/organ/target_implant
	var/datum/surgery/premium_augment_maintenance/premium_surgery = surgery
	if(istype(premium_surgery))
		target_implant = premium_surgery.selected_premium
	if(!target_implant || target_implant.owner != target || !target_implant.premium || target_implant.zone != target_zone)
		target_implant = null
	if(!target_implant)
		to_chat(user, span_warning("[target] has no premium augments there to service!"))
		return ..()

	target_implant.premium_component?.apply_premium_maintenance(AUGMENTED_PREMIUM_QUALITY_START)

	if(target_zone == BODY_ZONE_PRECISE_EYES || target_zone == BODY_ZONE_PRECISE_MOUTH)
		target_zone = check_zone(target_zone)
	display_results(
		user,
		target,
		span_notice("You successfully service [target]'s [target_implant.name] in [target.parse_zone_with_bodypart(target_zone)]."),
		span_notice("[user] successfully services [target]'s [target_implant.name] in [target.parse_zone_with_bodypart(target_zone)]."),
		span_notice("[user] successfully services something inside [target]'s [target.parse_zone_with_bodypart(target_zone)]."),
	)
	log_combat(user, target, "serviced premium augments in", addition="COMBAT MODE: [uppertext(user.combat_mode)]")
	return ..()
