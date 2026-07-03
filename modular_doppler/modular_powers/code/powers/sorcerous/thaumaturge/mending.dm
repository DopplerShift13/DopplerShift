/*
	Its like the welder from Phantasmal Tool but its magical, doesnt need protective glasses and does a bunch more useful things.
	As a brief overview, it does the following:
	- Mends borgs & bots.
	- Mends mechs.
	- Mends structures.
	- Mends glass shards into glass.
	- Mends damaged/burned clothing, including EMP'd suit sensors.
	- Mends inorganic organs if they are outside of the mob.
	- Mends inorganic mob parts if they are on a mob. Uses targeting dummy.
	- Restores 10% quality on premium augments, caps out at 50%. Does not work at 0%. Uses targeting dummy.
*/
/datum/power/thaumaturge/mending
	name = "Mending"
	desc = "Removes wear and damage from various items, structures and inorganic mobs. This will usually heal 15 health or 10% of its health, whichever is bigger. \
	\nRequires Affinity 1 to cast. Affinity gives a chance to not consume charges on cast."
	security_record_text = "Subject can mend damage objects with a touch."
	value = 2

	action_path = /datum/action/cooldown/power/thaumaturge/mending
	required_powers = list(/datum/power/thaumaturge_root)
	required_allow_subtypes = TRUE

/datum/action/cooldown/power/thaumaturge/mending
	name = "Mending"
	desc = "Removes wear and damage from various items, structures and inorganic mobs. This will usually heal 15 health or 10% of its health, whichever is bigger."
	button_icon = 'icons/obj/tools.dmi'
	button_icon_state = "wrench_brass"

	required_affinity = 1
	prep_cost = 2
	power_refunds = TRUE
	power_refund_chance = THAUMATURGE_REFUND_MULT_BASE
	power_refund_affinity_bonus = THAUMATURGE_REFUND_MULT_AFFINITY

	click_to_activate = TRUE
	aim_assist = FALSE // I see some use-cases where what you want to target is very finnicky and that you don't want to default to humanoid targets.

	/// How much Mending restores
	var/heal_amount = 15
	/// How much % of Health to restore if it is bigger than the base healing.
	var/heal_amount_percent = 10
	/// How much Quality Mending restores on Premium Augments
	var/quality_amount = 10
	/// How much Quality can Mending restore at the max on Premium Augments?
	var/max_quality_percent = 50

/datum/action/cooldown/power/thaumaturge/mending/InterceptClickOn(mob/living/clicker, params, atom/target)
	..()
	return TRUE // Always consume the click to avoid normal click interactions.

/datum/action/cooldown/power/thaumaturge/mending/use_action(mob/living/user, atom/target)
	/// Heals silicons or bots
	if(istype(target, /mob/living/silicon) || istype(target, /mob/living/basic/bot) || istype(target, /mob/living/simple_animal/bot))
		var/mob/living/target_living = target
		if(!repair_synthetic_mob(target_living))
			user.balloon_alert(user, "target is not damaged!")
			return FALSE
		play_mending_feedback(user, target, "damage")
		return TRUE

	/// Heals mechs
	if(istype(target, /obj/vehicle/sealed/mecha))
		var/obj/vehicle/sealed/mecha/target_mecha = target
		if(!repair_integrity_target(target_mecha, get_mending_amount(target_mecha.max_integrity)))
			user.balloon_alert(user, "target is not damaged!")
			return FALSE
		play_mending_feedback(user, target, "damage")
		return TRUE

	/// Heals structures
	if(istype(target, /obj/structure))
		var/obj/structure/target_structure = target
		if(!target_structure.uses_integrity || !repair_integrity_target(target_structure, get_mending_amount(target_structure.max_integrity)))
			user.balloon_alert(user, "target is not damaged!")
			return FALSE
		play_mending_feedback(user, target, "damage")
		return TRUE

	/// Reforms glass shards back into their parent sheet material.
	if(istype(target, /obj/item/shard))
		var/obj/item/shard/target_shard = target
		var/obj/item/stack/sheet/repaired_sheet = repair_shard(target_shard)
		if(!repaired_sheet)
			user.balloon_alert(user, "invalid target!")
			return FALSE
		play_mending_feedback(user, repaired_sheet, "fractures")
		return TRUE

	/// Heals damaged clothing and broken suit sensors.
	if(istype(target, /obj/item/clothing))
		var/obj/item/clothing/target_clothing = target
		if(!repair_clothing(target_clothing))
			user.balloon_alert(user, "target is not damaged!")
			return FALSE
		play_mending_feedback(user, target, "damage")
		return TRUE

	/// Heals detached synthetic organs.
	if(istype(target, /obj/item/organ))
		var/obj/item/organ/target_organ = target
		if(!can_repair_synthetic_organ(target_organ))
			user.balloon_alert(user, "invalid target!")
			return FALSE
		if(!repair_synthetic_organ(target_organ))
			user.balloon_alert(user, "target is not damaged!")
			return FALSE
		play_mending_feedback(user, target, "damage")
		return TRUE

	/// Heals targeted synthetic limbs attached to a carbon mob.
	var/mob/living/carbon/target_carbon = resolve_target_bodypart_owner(user, target)
	if(target_carbon)
		var/obj/item/bodypart/target_bodypart = target_carbon.get_bodypart(check_zone(user.zone_selected))
		if(!repair_synthetic_bodypart(target_carbon, target_bodypart))
			user.balloon_alert(user, "target is not damaged!")
			return FALSE
		play_mending_feedback(user, target, "damage")
		return TRUE

	/// Restores maintenance quality on premium augments.
	var/obj/item/organ/target_premium_augment = resolve_target_premium_augment(user, target)
	if(target_premium_augment)
		if(!repair_premium_augment(target_premium_augment))
			user.balloon_alert(user, "target is not damaged!")
			return FALSE
		play_mending_feedback(user, target, "quality")
		return TRUE

	/// No target found
	user.balloon_alert(user, "invalid target!")
	return FALSE

/// Returns how much we should heal with mending, based upon the target's max health value.
/datum/action/cooldown/power/thaumaturge/mending/proc/get_mending_amount(maximum_health)
	return max(heal_amount, round(maximum_health * (heal_amount_percent / 100), DAMAGE_PRECISION))

/// Resolves a clicked carbon target into the owner of the robotic bodypart in the user's selected zone.
/datum/action/cooldown/power/thaumaturge/mending/proc/resolve_target_bodypart_owner(mob/living/user, atom/target)
	if(!iscarbon(target))
		return null

	var/mob/living/carbon/target_carbon = target
	var/obj/item/bodypart/targeted_bodypart = target_carbon.get_bodypart(check_zone(user.zone_selected))
	if(!targeted_bodypart || !IS_ROBOTIC_LIMB(targeted_bodypart))
		return null
	return target_carbon

/// Resolves a clicked target into a premium augment, either directly or from the user's selected body zone.
/datum/action/cooldown/power/thaumaturge/mending/proc/resolve_target_premium_augment(mob/living/user, atom/target)
	if(istype(target, /obj/item/organ))
		var/obj/item/organ/target_organ = target
		if(target_organ.premium && target_organ.premium_component && target_organ.premium_component.quality < max_quality_percent)
			return target_organ
		return null

	if(!iscarbon(target))
		return null

	var/mob/living/carbon/target_carbon = target
	var/list/zone_organs = target_carbon.get_organs_for_zone(user.zone_selected)
	for(var/obj/item/organ/target_organ as anything in zone_organs)
		if(target_organ.premium && target_organ.premium_component && target_organ.premium_component.quality < max_quality_percent)
			return target_organ
	return null

/// VFX of the mending spell succeeding
/datum/action/cooldown/power/thaumaturge/mending/proc/play_mending_feedback(mob/living/user, atom/target, repaired_thing)
	// Flash similar to presti to show it has been mended
	var/filter_id = "mending_flash"
	target.add_filter(filter_id, 1, list(type = "outline", color = "#7266dd", size = 2, alpha = 255))
	target.transition_filter(filter_id, list("alpha" = 0), 2 SECONDS)
	addtimer(CALLBACK(target, PROC_REF(remove_filter), filter_id), 2 SECONDS)

	// Sound and feedback of the mending
	playsound(target, 'sound/effects/magic/summon_guns.ogg', 50, TRUE, MEDIUM_RANGE_SOUND_EXTRARANGE) // yes its summon guns, sue me
	user.visible_message(
		span_notice("[user] mends some of [target]'s [repaired_thing]."),
		span_notice("You mend some of [target]'s [repaired_thing]."),
		visible_message_flags = ALWAYS_SHOW_SELF_MESSAGE,
	)

/// Integrity heal for structures
/datum/action/cooldown/power/thaumaturge/mending/proc/repair_integrity_target(atom/damaged_atom, amount_to_repair)
	if(!damaged_atom?.uses_integrity)
		return FALSE
	if(damaged_atom.get_integrity() >= damaged_atom.max_integrity)
		return FALSE
	return damaged_atom.repair_damage(amount_to_repair) > 0

/// Repairs damaged clothing and, for undersuits, broken sensors.
/// Clothing damage states are binary, so damaged or shredded clothes are restored in full.
/datum/action/cooldown/power/thaumaturge/mending/proc/repair_clothing(obj/item/clothing/target_clothing)
	var/did_repair = FALSE

	if(target_clothing.damaged_clothes != CLOTHING_PRISTINE)
		target_clothing.repair()
		did_repair = TRUE

	if(target_clothing.uses_integrity && target_clothing.get_integrity() < target_clothing.max_integrity)
		did_repair = repair_integrity_target(target_clothing, get_mending_amount(target_clothing.max_integrity))

	if(istype(target_clothing, /obj/item/clothing/under))
		var/obj/item/clothing/under/target_under = target_clothing
		if(target_under.has_sensor == BROKEN_SENSORS)
			did_repair = target_under.repair_sensors() || did_repair

	return did_repair

/// Reforms a glass shard into one sheet of its source material.
/datum/action/cooldown/power/thaumaturge/mending/proc/repair_shard(obj/item/shard/target_shard)
	if(!target_shard?.weld_material)
		return null

	var/turf/drop_turf = get_turf(target_shard)
	if(!drop_turf)
		return null

	var/obj/item/stack/sheet/repaired_sheet = new target_shard.weld_material(drop_turf)
	qdel(target_shard)
	return repaired_sheet

/// Synthetic organs can only be mended while fully detached from any mob or bodypart.
/datum/action/cooldown/power/thaumaturge/mending/proc/can_repair_synthetic_organ(obj/item/organ/target_organ)
	if(!target_organ)
		return FALSE
	if(!IS_ROBOTIC_ORGAN(target_organ))
		return FALSE
	if(target_organ.owner || target_organ.bodypart_owner)
		return FALSE
	return TRUE

/// Restores premium augment quality by 10%, but never above the spell's maintenance ceiling and never from 0%.
/datum/action/cooldown/power/thaumaturge/mending/proc/repair_premium_augment(obj/item/organ/target_organ)
	if(!target_organ?.premium || !target_organ.premium_component)
		return FALSE

	var/datum/component/premium_augment/premium_component = target_organ.premium_component
	if(premium_component.quality <= 0 || premium_component.quality >= max_quality_percent)
		return FALSE

	var/starting_quality = premium_component.quality
	premium_component.adjust_quality(quality_amount, max_quality_percent)
	return premium_component.quality > starting_quality

/// Repairs damage on a detached synthetic organ.
/datum/action/cooldown/power/thaumaturge/mending/proc/repair_synthetic_organ(obj/item/organ/target_organ)
	if(!can_repair_synthetic_organ(target_organ))
		return FALSE
	if(target_organ.damage <= 0)
		return FALSE

	var/amount_to_repair = get_mending_amount(target_organ.maxHealth)
	return target_organ.apply_organ_damage(-amount_to_repair, required_organ_flag = ORGAN_ROBOTIC) > 0

/// Repairs a robotic limb selected from a carbon mob by healing the targeted zone on the mob.
/datum/action/cooldown/power/thaumaturge/mending/proc/repair_synthetic_bodypart(mob/living/carbon/target_carbon, obj/item/bodypart/target_bodypart)
	if(!target_carbon || !IS_ROBOTIC_LIMB(target_bodypart))
		return FALSE

	var/amount_to_repair = get_mending_amount(target_bodypart.max_damage)
	return target_carbon.heal_bodypart_damage(
		brute = amount_to_repair,
		burn = amount_to_repair,
		required_bodytype = BODYTYPE_ROBOTIC,
		target_zone = target_bodypart.body_zone,
	) > 0

/// Shared healing for inorganic mobs that use normal brute and burn damage tracks.
/datum/action/cooldown/power/thaumaturge/mending/proc/repair_synthetic_mob(mob/living/target_living)
	var/brute_damage = target_living.getBruteLoss()
	var/burn_damage = target_living.getFireLoss()
	var/total_damage = brute_damage + burn_damage
	if(total_damage <= 0)
		return FALSE

	var/amount_to_repair = get_mending_amount(target_living.maxHealth)
	var/brute_to_repair = 0
	var/burn_to_repair = 0

	if(brute_damage >= burn_damage)
		brute_to_repair = min(amount_to_repair, brute_damage)
		burn_to_repair = min(amount_to_repair - brute_to_repair, burn_damage)
	else
		burn_to_repair = min(amount_to_repair, burn_damage)
		brute_to_repair = min(amount_to_repair - burn_to_repair, brute_damage)

	target_living.heal_overall_damage(brute = brute_to_repair, burn = burn_to_repair)
	return TRUE
