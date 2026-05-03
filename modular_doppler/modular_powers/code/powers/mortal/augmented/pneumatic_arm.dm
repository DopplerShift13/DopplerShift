/*
	Its an arm that makes you punch harder and be activated to punch EVEN HARDER.
*/
/datum/power/augmented/pneumatic_arm
	name = "Premium DSTR Pneumatic Arm"
	desc = "A popular choice for the augmented bodyguards and manufactured by Praetor Dynamics. Passively increases your punch damage by +5 with that arm. \
	\n In addition, it allows you actively 'overcharge' the arm, making your next punch knockback someoneone 1 space (potentially stunning them on walls) and dealing an additional 15 brute damage in exchange for a hefty quality cost.\
	\n Quality decreases from using the pneumatic arm's active ability. Quality affects damage (passive and active)."
	security_record_text = "Subject has a DSTR Pneumatic Arm, increasing their lethality with unarmed strikes."
	security_threat = POWER_THREAT_MAJOR

	value = 4 // balance around 2 arms.
	augment = /obj/item/organ/cyberimp/arm/pneumatic_arm

/obj/item/organ/cyberimp/arm/pneumatic_arm
	name = "DSTR Pneumatic Arm"
	desc = "A popular choice for the augmented bodyguards and manufactured by Praetor Dynamics. Passively increases your punch damage by +5 with that arm. \
	\n In addition, it allows you actively 'overcharge' the arm, making your next punch knockback someoneone 1 space (potentially stunning them on walls) and dealing an additional 15 brute damage in exchange for a hefty quality cost.\
	\n Quality decreases from using the pneumatic arm's active ability. Quality affects damage (passive and active)."
	icon_state = "toolkit_generic"

	actions_types = list(/datum/action/item_action/organ_action/premium/use)
	premium = TRUE

	/// Going to deal the extra damage + knockback when punching
	var/overcharged = FALSE

	/// Bonus damage while not active
	var/bonus_passive_damage = 5
	/// Bonus damage while active
	var/bonus_active_damage = 15

	/// Knockback on punch while active
	var/knockback = 1
	/// Is the throw 'safe'? False means it can cause wallstuns and such.
	var/gentle_throw = FALSE

	/// EMP cooldown decleration
	COOLDOWN_DECLARE(emp_reenable_cooldown)
	/// EMP cooldown time
	var/emp_cooldown = 30 SECONDS

/obj/item/organ/cyberimp/arm/pneumatic_arm/Initialize(mapload)
	. = ..()
	if(premium_component)
		premium_component.refurb_parts = list(
			/obj/item/stack/sheet/iron = 5,
			/obj/item/stack/sheet/plasteel = 2,
			/obj/item/stack/cable_coil = 2,
			/obj/item/stock_parts/servo/femto = 1)

/obj/item/organ/cyberimp/arm/pneumatic_arm/on_mob_insert(mob/living/carbon/arm_owner)
	. = ..()
	RegisterSignal(arm_owner, COMSIG_HUMAN_UNARMED_HIT, PROC_REF(on_unarmed_hit))

/obj/item/organ/cyberimp/arm/pneumatic_arm/on_mob_remove(mob/living/carbon/arm_owner)
	. = ..()
	UnregisterSignal(arm_owner, COMSIG_HUMAN_UNARMED_HIT)

// On EMP
/obj/item/organ/cyberimp/arm/pneumatic_arm/emp_act(severity)
	. = ..()
	if(. & EMP_PROTECT_SELF)
		return
	if(premium_component)
		premium_component.adjust_quality(-AUGMENTED_PREMIUM_QUALITY_MINOR)
	overcharged = FALSE
	COOLDOWN_START(src, emp_reenable_cooldown, emp_cooldown)
	premium_component?.update_quality_actions()
	to_chat(owner, span_warning("Your [name] becomes disabled!"))

/// Triggers the on-hit with punch effects, either pasive or active.
/obj/item/organ/cyberimp/arm/pneumatic_arm/proc/on_unarmed_hit(mob/living/user, mob/living/target, obj/item/bodypart/affecting, damage, armor_block, limb_sharpness)
	SIGNAL_HANDLER
	if(!target || !premium_component?.can_function())
		return

	// No bonus damage if EMP'd
	if(!COOLDOWN_FINISHED(src, emp_reenable_cooldown))
		return

	// Only applies bonus damage when the arm is the active arm.
	if(user.get_active_hand() != hand)
		return

	var/efficiency = premium_component.get_efficiency()
	if(efficiency <= 0)
		return

	// Bonus damage when punching
	var/passive_damage = round(bonus_passive_damage * efficiency, DAMAGE_PRECISION)
	if(passive_damage > 0)
		target.apply_damage(passive_damage, BRUTE, affecting, armor_block, sharpness = limb_sharpness)

	// If active; smack extra-hard.
	if(overcharged)
		var/active_damage = round(bonus_active_damage * efficiency, DAMAGE_PRECISION)
		if(active_damage > 0)
			target.apply_damage(active_damage, BRUTE, affecting, armor_block, sharpness = limb_sharpness)

		if(ismovable(target))
			var/throw_dir = get_dir(user, target)
			if(throw_dir)
				var/atom/throw_target = get_edge_target_turf(target, throw_dir)
				target.throw_at(throw_target, knockback, 2, user, gentle = gentle_throw)
		to_chat(target, span_userdanger("[user]'s punch sends you flying!"))
		playsound(target, 'sound/items/weapons/resonator_blast.ogg', 75, TRUE)
		premium_component.adjust_quality(-AUGMENTED_PREMIUM_QUALITY_MINOR)

/obj/item/organ/cyberimp/arm/pneumatic_arm/use_action()
	if(!owner)
		return FALSE
	if(!overcharged && !COOLDOWN_FINISHED(src, emp_reenable_cooldown))
		to_chat(owner, span_warning("Your [name] is temporarily disabled from EMP interference."))
		return FALSE
	if(!premium_component?.can_function())
		to_chat(owner, span_warning("Your [name] fails to respond; it seems broken!"))
		return FALSE
	if(overcharged)
		to_chat(owner, span_notice("You return your [name] to its standard settings."))
		overcharged = FALSE
		return TRUE
	overcharged = TRUE
	to_chat(owner, span_notice("You overcharge your [name]. Your next punch will knock back your target."))
	return TRUE

/obj/item/organ/cyberimp/arm/pneumatic_arm/is_action_active()
	return overcharged
