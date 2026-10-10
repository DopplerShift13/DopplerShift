/datum/power/aberrant/raking_claws_monstrous_upgrade
	name = "Life-Leeching Claws"
	desc = "Your raking claws rejuvenate you with each drop of blood you draw. Whilst at maximum Bloodlust, strikes against living targets or corpses with blood heal up to 1 brute damage across fleshy bodyparts and your transformed arms based on how much percentage of the damage was dealt as unmitigated damage. The helaing is doubled against large targets. \
	\nButchering a corpse grants 10 Bloodlust and heals 15 brute damage."
	security_record_text = "Subject claws can mend their wounds by maiming and butchering other creatures."
	security_threat = POWER_THREAT_MAJOR
	value = 2
	magic_flags = POWER_MAGIC_STANDARD
	required_powers = list(/datum/power/aberrant/raking_claws, /datum/power/aberrant_root/monstrous)

	menu_icon = 'modular_doppler/modular_powers/icons/items/beastarm_items.dmi'
	menu_icon_state = "arm_fur4"

	/// Brute damage healed when a strike deals all of its unmitigated damage.
	var/bloodlust_base_heal = 1
	/// Multiplier applied to strike healing against large targets.
	var/bloodlust_large_heal_mult = 2
	/// Fixed brute healing granted after butchering.
	var/butcher_heal = 15
	/// Bloodlust stacks granted after butchering.
	var/butcher_bloodlust = 10

/datum/power/aberrant/raking_claws_monstrous_upgrade/add(client/client_source)
	RegisterSignal(power_holder, COMSIG_RAKING_CLAW_AFTER_DAMAGE, PROC_REF(on_claw_damage))
	RegisterSignal(power_holder, COMSIG_RAKING_CLAW_BUTCHERED, PROC_REF(on_claw_butchering))

/datum/power/aberrant/raking_claws_monstrous_upgrade/remove()
	UnregisterSignal(power_holder, list(COMSIG_RAKING_CLAW_AFTER_DAMAGE, COMSIG_RAKING_CLAW_BUTCHERED))

/// Converts the post-mitigation portion of a maximum-Bloodlust hit into brute healing.
/datum/power/aberrant/raking_claws_monstrous_upgrade/proc/on_claw_damage(mob/living/claw_user, obj/item/raking_claw/claw, mob/living/target, damage_dealt, unmitigated_damage, obj/item/bodypart/hit_bodypart)
	SIGNAL_HANDLER
	if(damage_dealt <= 0 || unmitigated_damage <= 0)
		return
	var/datum/status_effect/raking_claw_bloodlust/bloodlust = claw_user.has_status_effect(/datum/status_effect/raking_claw_bloodlust)
	if(isnull(bloodlust) || bloodlust.stacks < bloodlust.max_stacks)
		return
	// Bloody corpses deliberately remain valid so the user can keep clawing into them with suitably gory results.
	if(target.stat == DEAD && target.can_bleed(BLOOD_COVER_TURFS) != BLEED_SPLATTER)
		return

	var/damage_dealt_percentage = clamp(damage_dealt / unmitigated_damage, 0, 1)
	var/healing_multiplier = target.mob_size >= MOB_SIZE_LARGE ? bloodlust_large_heal_mult : 1
	heal_bloodlust_brute(claw_user, bloodlust_base_heal * damage_dealt_percentage * healing_multiplier)

/// Rewards completing a butcher with Bloodlust and a fixed amount of brute healing.
/datum/power/aberrant/raking_claws_monstrous_upgrade/proc/on_claw_butchering(mob/living/butcher, obj/item/raking_claw/claw, mob/living/target)
	SIGNAL_HANDLER
	butcher.apply_status_effect(/datum/status_effect/raking_claw_bloodlust, butcher_bloodlust)
	heal_bloodlust_brute(butcher, butcher_heal)
	butcher.visible_message(
		span_warning("[butcher] butchers [target] with a bloodthirsty look!"),
		span_notice("You revel in the bloodshed of tearing [target] apart! You feel invigorated."),
	)

/// Heals organic bodyparts and transformed arms while leaving other prosthetic bodyparts damaged.
/// Transformed arms deliberately remain eligible even when prosthetic.
/datum/power/aberrant/raking_claws_monstrous_upgrade/proc/heal_bloodlust_brute(mob/living/claw_user, healing_amount)
	if(!iscarbon(claw_user))
		claw_user.adjustBruteLoss(-healing_amount)
		return

	var/mob/living/carbon/carbon_user = claw_user
	var/list/obj/item/bodypart/eligible_bodyparts = list()
	for(var/obj/item/bodypart/bodypart as anything in carbon_user.bodyparts)
		if(bodypart.brute_dam > 0 && ((bodypart.bodytype & BODYTYPE_ORGANIC) || (bodypart.body_zone in GLOB.arm_zones)))
			eligible_bodyparts += bodypart

	var/remaining_healing = healing_amount
	while(remaining_healing > 0 && length(eligible_bodyparts))
		var/obj/item/bodypart/selected_bodypart = pick(eligible_bodyparts)
		var/brute_before_healing = selected_bodypart.brute_dam
		selected_bodypart.heal_damage(remaining_healing, 0, updating_health = FALSE, required_bodytype = NONE)
		remaining_healing -= brute_before_healing - selected_bodypart.brute_dam
		eligible_bodyparts -= selected_bodypart

	carbon_user.updatehealth()
	carbon_user.update_damage_overlays()
