/*
	Spray reagents EVERYWHERE!
*/
/datum/power/augmented/reagent_cannon
	name = "Premium SPRY Reagent Cannon"
	desc = "Usually included in various company contracts, those who work in mega-scale botanics and cleaning need to push for optimal efficiency. Manufactured by Nex-Zephyr, this beauty will be your lifelong replacement of a spray bottle.\
	\n When activated, transform your arm into a chemsprayer, allowing you to deploy chemicals rapidly in a large area. Capable of containing up to 600 chemicals. \
	\n Because this is an incredibly invasive augment, this requires a cybernetic arm to wield effectively. Your arm will be replaced with a synthetic variant at roundstart to facilitate this."
	security_record_text = "Subject has an industrial SRPY Reagent cannon embedded in their arm."
	security_threat = POWER_THREAT_MAJOR // it is still a chemsprayer if you put murder chems in this it will kill

	value = 5
	augment = /obj/item/organ/cyberimp/arm/toolkit/reagent_cannon

// Replaces the existing arm with a robot limb.
/datum/power/augmented/reagent_cannon/add_unique(client/client_source)
	var/mob/living/carbon/human/human_holder = power_holder
	if(!augment || !human_holder)
		return
	var/augment_left = client_source?.prefs?.read_preference(/datum/preference/choiced/augment_left)
	var/augment_right = client_source?.prefs?.read_preference(/datum/preference/choiced/augment_right)
	var/left_match = augment_matches_pref(augment_left)
	var/right_match = augment_matches_pref(augment_right)

	if(left_match)
		replace_arm_with_robot(human_holder, BODY_ZONE_L_ARM)
	if(right_match)
		replace_arm_with_robot(human_holder, BODY_ZONE_R_ARM)
	return ..()

/// Swaps your arm with a robotic one because feeble human arms aren't good enough for this.
/datum/power/augmented/reagent_cannon/proc/replace_arm_with_robot(mob/living/carbon/human/human_holder, arm_zone)
	if(!human_holder)
		return
	var/obj/item/bodypart/existing = human_holder.get_bodypart(arm_zone)
	if(existing && (existing.bodytype & BODYTYPE_ROBOTIC)) // we already have robo arms.
		return
	if(arm_zone == BODY_ZONE_L_ARM)
		human_holder.del_and_replace_bodypart(new /obj/item/bodypart/arm/left/robot, special = TRUE)
	else if(arm_zone == BODY_ZONE_R_ARM)
		human_holder.del_and_replace_bodypart(new /obj/item/bodypart/arm/right/robot, special = TRUE)

/obj/item/organ/cyberimp/arm/toolkit/reagent_cannon
	name = "Premium SPRY Reagent Cannon"
	desc = "Usually included in various company contracts, those who work in mega-scale botanics and cleaning need to push for optimal efficiency. Manufactured by Nex-Zephyr, this beauty will be your lifelong replacement of a spray bottle.\
	\n When activated, transform your arm into a chemsprayer, allowing you to deploy chemicals rapidly in a large area. Capable of containing up to 600 chemicals. \
	\n Because this is an incredibly invasive augment, this requires a cybernetic arm to wield effectively."
	icon = 'icons/obj/weapons/guns/ballistic.dmi'
	icon_state = "chemsprayer"

	actions_types = list(/datum/action/item_action/organ_action/premium/use)
	premium = TRUE

	items_to_create = list(/obj/item/reagent_containers/spray/chemsprayer/reagent_cannon)

	/// Base chance not to consume quality on spray, scaling with amount sprayed and quality.
	var/quality_chance = 40

	/// EMP cooldown declaration
	COOLDOWN_DECLARE(emp_reenable_cooldown)
	/// EMP cooldown duration
	var/emp_cooldown = 30 SECONDS

/obj/item/organ/cyberimp/arm/toolkit/reagent_cannon/Initialize(mapload)
	. = ..()
	if(premium_component)
		premium_component.refurb_parts = list(
			/obj/item/stack/sheet/plastic = 5,
			/obj/item/stack/sheet/iron = 2,
			/obj/item/stack/cable_coil = 2,
			/obj/item/stock_parts/matter_bin/bluespace = 1)

// Only fits in cybernetic arms because fluff and also how the fuck does it fit elsewhere.
/obj/item/organ/cyberimp/arm/toolkit/reagent_cannon/on_mob_insert(mob/living/carbon/arm_owner)
	. = ..()
	if(!has_robotic_arm())
		to_chat(arm_owner, span_warning("Your [name] does not fit in a non-cybernetic arm!"))
		return

// On EMP
/obj/item/organ/cyberimp/arm/toolkit/reagent_cannon/emp_act(severity)
	. = ..()
	if(. & EMP_PROTECT_SELF)
		return
	if(premium_component)
		premium_component.adjust_quality(-AUGMENTED_PREMIUM_QUALITY_MINOR)
	Retract()
	COOLDOWN_START(src, emp_reenable_cooldown, emp_cooldown)
	premium_component?.update_quality_actions()
	to_chat(owner, span_warning("Your [name] becomes disabled!"))

/obj/item/organ/cyberimp/arm/toolkit/reagent_cannon/use_action()
	if(!owner)
		return FALSE
	if(!has_robotic_arm())
		to_chat(owner, span_warning("Your [name] can't function with a non-cybernetic arm."))
		return FALSE
	if(!premium_component?.can_function())
		to_chat(owner, span_warning("Your [name] fails to respond; it seems broken!"))
		return FALSE
	if(!COOLDOWN_FINISHED(src, emp_reenable_cooldown) && !is_action_active())
		to_chat(owner, span_warning("Your [name] is temporarily disabled from EMP interference."))
		return FALSE
	var/obj/item/active = active_item
	if(active && !(active in src))
		return Retract()
	if(!LAZYLEN(contents))
		return FALSE
	Extend(contents[1])
	return TRUE

/obj/item/organ/cyberimp/arm/toolkit/reagent_cannon/is_action_active()
	return active_item && !(active_item in src)

/// All around check if theres a robotic arm.
/obj/item/organ/cyberimp/arm/toolkit/reagent_cannon/proc/has_robotic_arm()
	var/obj/item/bodypart/arm_part = hand
	if(!arm_part)
		return FALSE
	return (arm_part.bodytype & BODYTYPE_ROBOTIC)

/// Chance to deduct quality based on amount used.
/obj/item/organ/cyberimp/arm/toolkit/reagent_cannon/proc/on_spray_used(reagents_used)
	if(!premium_component)
		return
	if(!premium_component.can_function())
		return
	var/efficiency = premium_component.get_efficiency()
	var/chance_no_consume = (quality_chance * efficiency) - max(reagents_used, 0)
	if(prob(clamp(chance_no_consume, 0, 100)))
		return
	premium_component.adjust_quality(-AUGMENTED_PREMIUM_QUALITY_TRIVIAL * 2)


// The chem sprayer specifically designed for the augment.
/obj/item/reagent_containers/spray/chemsprayer/reagent_cannon
	name = "Premium SPRY Reagent Cannon"
	desc = "A chem sprayer integrated into a premium arm augment. Really it's a miracle you even have an operable hand with the size of this thing. Comes with a 'focused' mode which tightens the spread of the cannon."
	var/obj/item/organ/cyberimp/arm/toolkit/reagent_cannon/host_implant
	/// 0 = spray wide, 1 = stream wide, 2 = spray focused, 3 = stream focused
	var/mode = 0
	/// Focused mode only targets the center tile (1-wide)
	var/focused_mode = FALSE

/obj/item/reagent_containers/spray/chemsprayer/reagent_cannon/Initialize(mapload)
	. = ..()
	if(istype(loc, /obj/item/organ/cyberimp/arm/toolkit/reagent_cannon))
		host_implant = loc

// We use a delta to get the amount we used and then pass that along to the augment for quality degredation.
/obj/item/reagent_containers/spray/chemsprayer/reagent_cannon/try_spray(atom/target, mob/user)
	var/before = reagents?.total_volume || 0
	. = ..()
	if(.)
		var/after = reagents?.total_volume || 0
		var/used = max(before - after, 0)
		host_implant?.on_spray_used(used)
	return .

// Allows us to basically toggle between 1x or 3x spray.
/obj/item/reagent_containers/spray/chemsprayer/reagent_cannon/spray(atom/A, mob/user)
	if(!host_implant?.premium_component.can_function())
		to_chat(user, span_warning("Your [name] fails to respond; it seems broken!"))
		return FALSE
	var/turf/target_turf = get_turf(A)
	if(focused_mode)
		call(src, /obj/item/reagent_containers/spray/proc/spray)(target_turf, user) // only way we can get a 1x1 spray because the chemsprayer is our parent and that overrides standard spray rules.
		return
	..()

// Allows us to switch between focused (1x wide) or unfocused (3x wide)
/obj/item/reagent_containers/spray/chemsprayer/reagent_cannon/toggle_stream_mode(mob/user)
	if(stream_range == spray_range || !stream_range || !spray_range || possible_transfer_amounts.len > 2 || !can_toggle_range)
		return
	mode = (mode + 1) % 4
	switch(mode)
		if(0)
			stream_mode = FALSE
			focused_mode = FALSE
			current_range = spray_range
			to_chat(user, span_notice("You switch the nozzle setting to \"spray\"."))
		if(1)
			stream_mode = TRUE
			focused_mode = FALSE
			current_range = stream_range
			to_chat(user, span_notice("You switch the nozzle setting to \"stream\"."))
		if(2)
			stream_mode = FALSE
			focused_mode = TRUE
			current_range = spray_range
			to_chat(user, span_notice("You switch the nozzle setting to \"spray (focused)\"."))
		if(3)
			stream_mode = TRUE
			focused_mode = TRUE
			current_range = stream_range
			to_chat(user, span_notice("You switch the nozzle setting to \"stream (focused)\"."))
