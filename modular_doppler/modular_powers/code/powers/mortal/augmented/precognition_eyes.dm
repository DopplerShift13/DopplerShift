/*
	Its an arm that makes you punch harder and be activated to punch EVEN HARDER.
*/
/datum/power/augmented/precognition_eyes
	name = "Premium PRCG Precognitive Scanners"
	desc = "Though some market it as being able to see the future, this invention by Oracle Neuro-Systems is instead a specialized AI recognition model hooked into a BULLET DODGER skillchip, allowing you to automatically dodge any incoming projectiles.\
	\n This doesn't come without drawbacks, as the visual load is exhausting and suffers from the same drawbacks as the skillchip by tiring you out, causing more exhaustion than usual. This has no safeguard, meaning you can be stamina-critted by any projectiles.\
	\n Requires a BULLET DODGER Skillchip to function; comes pre-packaged with one at roundstart."
	security_record_text = "Subject has PRCG Precognitive Scanners, allowing them to automatically dodge projectiles at the cost of their stamina."
	security_threat = POWER_THREAT_MAJOR // it is still a chemsprayer if you put murder chems in this it will kill

	value = 8
	augment = /obj/item/organ/eyes/robotic/precognition_eyes

/obj/item/organ/eyes/robotic/precognition_eyes
	name = "Premium PRCG Precognitive Scanners"
	desc = "Though some market it as being able to see the future, this invention by Oracle Neuro-Systems is instead a specialized AI recognition model hooked into a BULLET DODGER skillchip, allowing you to automatically dodge any incoming projectiles.\
	\n This doesn't come without drawbacks, as the visual load is exhausting and suffers from the same drawbacks as the skillchip by tiring you out, causing more exhaustion than usual. This has no safeguard, meaning you can be stamina-critted by any projectiles.\
	\n Requires a BULLET DODGER Skillchip to function."
	icon_state = "eyes_cyber_xray"

	actions_types = list(/datum/action/item_action/organ_action/premium/use)
	premium = TRUE
	/// On or off state of the implant
	var/enabled = TRUE

	/// How much quality do we lose on trigger?
	var/quality_loss = AUGMENTED_PREMIUM_QUALITY_MINOR / 2
	/// Skillchip installed by this augment.
	var/obj/item/skillchip/installed_chip
	/// Did we add an extra skillchip slot?
	var/added_skillchip_slot = FALSE
	/// The minimum stamloss gained from this. Normally it is the projectile's damage * efficiency.
	var/dodge_stamloss = 30 // higher than normal taunting. Git gud.
	/// EMP cooldown decleration
	COOLDOWN_DECLARE(emp_reenable_cooldown)
	/// EMP cooldown duration
	var/emp_cooldown = 30 SECONDS


/obj/item/organ/eyes/robotic/precognition_eyes/Initialize(mapload)
	. = ..()
	if(premium_component)
		premium_component.refurb_parts = list(
			/obj/item/stack/sheet/glass = 2,
			/obj/item/stack/cable_coil = 1,
			/obj/item/stock_parts/scanning_module/triphasic = 1)

// Listeners if we are about to be hit by projectiles.
/obj/item/organ/eyes/robotic/precognition_eyes/on_mob_insert(mob/living/carbon/owner_mob)
	. = ..()
	grant_matrix_taunt(owner_mob)
	RegisterSignal(owner_mob, COMSIG_PROJECTILE_PREHIT, PROC_REF(on_projectile_prehit))

/obj/item/organ/eyes/robotic/precognition_eyes/on_mob_remove(mob/living/carbon/owner_mob)
	. = ..()
	if(owner_mob)
		UnregisterSignal(owner_mob, COMSIG_PROJECTILE_PREHIT)
	remove_matrix_taunt(owner_mob)

/// Grants the skillchip that's required to use it
/obj/item/organ/eyes/robotic/precognition_eyes/proc/grant_matrix_taunt(mob/living/carbon/owner_mob)
	if(!owner_mob || installed_chip)
		return
	var/obj/item/organ/brain/brain = owner_mob.get_organ_slot(ORGAN_SLOT_BRAIN)
	if(!brain)
		return
	if(has_matrix_taunt(brain))
		return
	brain.max_skillchip_slots += 1
	added_skillchip_slot = TRUE
	installed_chip = new /obj/item/skillchip/matrix_taunt()
	owner_mob.implant_skillchip(installed_chip, force = TRUE)
	installed_chip.try_activate_skillchip(silent = TRUE, force = TRUE)

/// Removes the skillchip; you don't get to keep it without the augment.
/obj/item/organ/eyes/robotic/precognition_eyes/proc/remove_matrix_taunt(mob/living/carbon/owner_mob)
	if(!owner_mob)
		return
	var/obj/item/organ/brain/brain = owner_mob.get_organ_slot(ORGAN_SLOT_BRAIN)
	if(added_skillchip_slot && brain)
		brain.max_skillchip_slots = max(brain.max_skillchip_slots - 1, 0)
		brain.update_skillchips()
	added_skillchip_slot = FALSE
	if(installed_chip)
		owner_mob.remove_skillchip(installed_chip, silent = TRUE)
		QDEL_NULL(installed_chip)

/// Checks if we have the required skillchip.
/obj/item/organ/eyes/robotic/precognition_eyes/proc/has_matrix_taunt(obj/item/organ/brain/brain)
	if(!brain || !length(brain.skillchips))
		return FALSE
	for(var/obj/item/skillchip/skillchip as anything in brain.skillchips)
		if(istype(skillchip, /obj/item/skillchip/matrix_taunt))
			return TRUE
	return FALSE

// On EMP
/obj/item/organ/eyes/robotic/precognition_eyes/emp_act(severity)
	. = ..()
	if(. & EMP_PROTECT_SELF)
		return
	if(premium_component)
		premium_component.adjust_quality(-quality_loss)
	enabled = FALSE
	COOLDOWN_START(src, emp_reenable_cooldown, emp_cooldown)
	premium_component?.update_quality_actions()
	to_chat(owner, span_warning("Your [name] becomes disabled!"))

// On using the action.
/obj/item/organ/eyes/robotic/precognition_eyes/use_action()
	if(!owner)
		return FALSE
	if(!enabled && !COOLDOWN_FINISHED(src, emp_reenable_cooldown))
		to_chat(owner, span_warning("Your [name] is temporarily disabled from EMP interference."))
		return FALSE
	enabled = !enabled
	if(enabled)
		to_chat(owner, span_notice("Your [name] is toggled on; it will now auto-dodge projectiles."))
	else
		to_chat(owner, span_notice("Your [name] is toggled off."))
	return enabled

/obj/item/organ/eyes/robotic/precognition_eyes/is_action_active()
	return enabled

/// Applies the dodge effects on pre-hit.
/obj/item/organ/eyes/robotic/precognition_eyes/proc/on_projectile_prehit(mob/living/source, obj/projectile/proj)
	SIGNAL_HANDLER
	if(source != owner)
		return NONE
	if(!enabled)
		return NONE
	if(!premium_component?.can_function())
		return NONE
	if(source.stat != CONSCIOUS || HAS_TRAIT(source, TRAIT_INCAPACITATED))
		return NONE
	if(HAS_TRAIT(source, TRAIT_UNHITTABLE_BY_PROJECTILES))
		return NONE
	ADD_TRAIT(source, TRAIT_UNHITTABLE_BY_PROJECTILES, AUGMENTATION_TRAIT)

	// stam + quality loss.
	var/efficiency = premium_component?.get_efficiency() || 1
	var/base_cost = dodge_stamloss
	// If the projectile deals more damage, we use that for stamina cost instead of dodge_stamloss.
	if(proj)
		base_cost = max(base_cost, proj.damage)
	source.adjustStaminaLoss(round(base_cost * (1 / max(efficiency, 0.01))))
	premium_component?.adjust_quality(-AUGMENTED_PREMIUM_QUALITY_MINOR)
	source.visible_message(span_warning("[source] dodges the [proj] with little effort!"), span_danger("You automatically dodge the [proj]!"))

	addtimer(TRAIT_CALLBACK_REMOVE(source, TRAIT_UNHITTABLE_BY_PROJECTILES, AUGMENTATION_TRAIT), 0.1 SECONDS)
	source.block_projectile_effects() // does all the vfx
	return PROJECTILE_INTERRUPT_HIT_PHASE
