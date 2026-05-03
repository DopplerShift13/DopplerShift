/// Surgery to service premium augments and restore their maintenance quality.

/datum/surgery/premium_augment_maintenance
	name = "Premium augment maintenance"
	desc = "Perform maintenance on premium augments, restoring them up to their standard operating quality."
	surgery_flags = SURGERY_REQUIRE_RESTING | SURGERY_REQUIRE_LIMB | SURGERY_REQUIRES_REAL_LIMB
	/// Selected premium augment to service for this surgery.
	var/obj/item/organ/cyberimp/selected_premium
	/// Zone used when selecting the premium augment.
	var/selected_premium_zone
	possible_locs = list(
		BODY_ZONE_HEAD,
		BODY_ZONE_CHEST,
		BODY_ZONE_L_ARM,
		BODY_ZONE_R_ARM,
		BODY_ZONE_L_LEG,
		BODY_ZONE_R_LEG,
		BODY_ZONE_PRECISE_EYES,
		BODY_ZONE_PRECISE_MOUTH,
		BODY_ZONE_PRECISE_GROIN,
		BODY_ZONE_PRECISE_L_HAND,
		BODY_ZONE_PRECISE_R_HAND,
		BODY_ZONE_PRECISE_L_FOOT,
		BODY_ZONE_PRECISE_R_FOOT,
	)
	steps = list(
		/datum/surgery_step/incise,
		/datum/surgery_step/retract_skin,
		/datum/surgery_step/clamp_bleeders,
		/datum/surgery_step/premium_augment_access,
		/datum/surgery_step/premium_augment_maintenance,
		/datum/surgery_step/close,
	)

/datum/surgery/premium_augment_maintenance/can_start(mob/user, mob/living/carbon/target)
	. = ..()
	if(!.)
		return .
	var/list/premium_augments = get_premium_augments_for_zone(target, user.zone_selected)
	return LAZYLEN(premium_augments)

/// Gets any premium augments that are in the selected zone
/datum/surgery/premium_augment_maintenance/proc/get_premium_augments_for_zone(mob/living/carbon/target, target_zone)
	if(!target)
		return null
	var/list/organs = target.get_organs_for_zone(target_zone)
	var/list/premium_augments = list()
	for(var/obj/item/organ/organ as anything in organs)
		var/obj/item/organ/cyberimp/implant = organ
		if(istype(implant) && implant.premium)
			premium_augments += implant
	return premium_augments

/// Gets which premium augment is chosen in the selected zone.
/datum/surgery/premium_augment_maintenance/proc/get_selected_premium(mob/user, mob/living/carbon/target, target_zone, obj/item/tool)
	if(!target)
		return null

	if(selected_premium && selected_premium.owner == target && selected_premium.premium && selected_premium.zone == target_zone)
		return selected_premium

	selected_premium = null
	selected_premium_zone = null

	var/list/premium_augments = get_premium_augments_for_zone(target, target_zone)
	if(!LAZYLEN(premium_augments))
		return null

	if(LAZYLEN(premium_augments) == 1)
		selected_premium = premium_augments[1]
		selected_premium_zone = target_zone
		return selected_premium

	var/list/options = list()
	for(var/obj/item/organ/cyberimp/implant as anything in premium_augments)
		var/label = implant.name
		if(options[label])
			label = "[label] ([implant.type])"
		options[label] = implant

	var/chosen = tgui_input_list(user, "Service which premium augment?", "Surgery", sort_list(options))
	if(isnull(chosen))
		return null

	if(!(user && target && user.Adjacent(target)))
		return null

	var/obj/item/held_tool = user.get_active_held_item()
	if(held_tool)
		held_tool = held_tool.get_proxy_attacker_for(target, user)
	if(held_tool != tool)
		return null

	selected_premium = options[chosen]
	if(!selected_premium || selected_premium.owner != target || !selected_premium.premium)
		selected_premium = null
		return null

	selected_premium_zone = target_zone
	return selected_premium

/datum/surgery/premium_augment_maintenance/mechanic
	name = "Premium augment maintenance"
	requires_bodypart_type = BODYTYPE_ROBOTIC
	surgery_flags = SURGERY_SELF_OPERABLE | SURGERY_REQUIRE_LIMB | SURGERY_CHECK_TOOL_BEHAVIOUR
	possible_locs = list(
		BODY_ZONE_HEAD,
		BODY_ZONE_CHEST,
		BODY_ZONE_L_ARM,
		BODY_ZONE_R_ARM,
		BODY_ZONE_L_LEG,
		BODY_ZONE_R_LEG,
		BODY_ZONE_PRECISE_EYES,
		BODY_ZONE_PRECISE_MOUTH,
		BODY_ZONE_PRECISE_GROIN,
		BODY_ZONE_PRECISE_L_HAND,
		BODY_ZONE_PRECISE_R_HAND,
		BODY_ZONE_PRECISE_L_FOOT,
		BODY_ZONE_PRECISE_R_FOOT,
	)
	steps = list(
		/datum/surgery_step/mechanic_open,
		/datum/surgery_step/open_hatch,
		/datum/surgery_step/prepare_electronics,
		/datum/surgery_step/premium_augment_access,
		/datum/surgery_step/premium_augment_maintenance,
		/datum/surgery_step/mechanic_close,
	)
