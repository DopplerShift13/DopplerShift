/datum/power/aberrant/raking_claws_bestial_upgrade
	name = "Maiming Claws"
	desc = "Your raking claws leave lasting, deadly wounds on target body parts. You will now aggravate any bleeding wounds on the target on hit, upgrading it to a more deadly version of the existing wound, scaling with Bloodlust.\
	\nIn addition, striking a limb that has the maximum accrued damage has a greatly increased chance to instantly dismember it proportional to your Bloodlust. This is calculated after the claws have struck that limb.\
	\nOn non-carbon targets, every stack of Bloodlust instead grants you +1 damage against that target."
	security_record_text = "Subject's claws can tear open existing wounds and sever heavily damaged limbs."
	security_threat = POWER_THREAT_MAJOR
	value = 2
	required_powers = list(/datum/power/aberrant/raking_claws, /datum/power/aberrant_root/beastial)
	magic_flags = NONE // bears do this shit and it ain't even magical.

	menu_icon = 'modular_doppler/modular_powers/icons/items/beastarm_items.dmi'
	menu_icon_state = "arm_fur2"

	/// Percentage chance per Bloodlust stack to promote a bleeding wound.
	var/aggravate_bleed_chance_per_stack = 10
	/// Base chance to dismember when at damage cap
	var/dismember_chance = 10
	/// Bonus chance to dismember when at damage cap per Bloodlust stack.
	var/dismember_bloodlust_bonus = 5
	/// Attack-modifier key tracking how much of this upgrade's bonus both attacks' shared modifier list already contains.
	var/static/bestial_force_modifier_key = "bestial_raking_claw_bonus_applied"

/datum/power/aberrant/raking_claws_bestial_upgrade/add(client/client_source)
	RegisterSignal(power_holder, COMSIG_RAKING_CLAW_MODIFY_ATTACK, PROC_REF(modify_claw_attack))
	RegisterSignal(power_holder, COMSIG_RAKING_CLAW_AFTER_DAMAGE, PROC_REF(on_claw_damage))

/datum/power/aberrant/raking_claws_bestial_upgrade/remove()
	UnregisterSignal(power_holder, list(COMSIG_RAKING_CLAW_MODIFY_ATTACK, COMSIG_RAKING_CLAW_AFTER_DAMAGE))

/// Gives each claw the current Bloodlust bonus against non-carbon targets without double-counting their shared modifiers.
/datum/power/aberrant/raking_claws_bestial_upgrade/proc/modify_claw_attack(mob/living/claw_user, obj/item/raking_claw/claw, mob/living/target, list/attack_modifiers)
	SIGNAL_HANDLER
	if(iscarbon(target))
		return
	var/datum/status_effect/raking_claw_bloodlust/bloodlust = claw_user.has_status_effect(/datum/status_effect/raking_claw_bloodlust)
	var/current_bonus = bloodlust?.stacks || 0
	var/previous_bonus = attack_modifiers[bestial_force_modifier_key] || 0
	if(current_bonus == previous_bonus)
		return
	MODIFY_ATTACK_FORCE(attack_modifiers, current_bonus - previous_bonus)
	// The off-hand inherits the existing bonus; only stacks earned by the first hit need adding before its attack.
	attack_modifiers[bestial_force_modifier_key] = current_bonus

/// Dismembers fully damaged limbs, then attempts to promote one existing bleeding wound.
/datum/power/aberrant/raking_claws_bestial_upgrade/proc/on_claw_damage(mob/living/claw_user, obj/item/raking_claw/claw, mob/living/target, damage_dealt, unmitigated_damage, obj/item/bodypart/hit_bodypart)
	SIGNAL_HANDLER
	if(!iscarbon(target) || isnull(hit_bodypart) || hit_bodypart.owner != target)
		return
	if(damage_dealt <= 0)
		return

	var/datum/status_effect/raking_claw_bloodlust/bloodlust = claw_user.has_status_effect(/datum/status_effect/raking_claw_bloodlust)
	// If the limb-part is at the damage cap.
	if((hit_bodypart.body_zone in GLOB.limb_zones) && (hit_bodypart.get_damage() >= hit_bodypart.max_damage))
		// Rolls a random chance to dismember the limb, with a bonus chance per stack of Bloodlust.
		if(prob(dismember_chance + (bloodlust?.stacks * dismember_bloodlust_bonus)) && hit_bodypart.dismember(BRUTE, FALSE, WOUND_SLASH))
			return // we already dismember the limb, no point in aggrevating.

	// Checks if we can aggravate an existing bleeding wound on the struck bodypart.
	if(isnull(bloodlust) || !prob(bloodlust.stacks * aggravate_bleed_chance_per_stack))
		return
	aggravate_bleeding_wound(claw_user, claw, target, hit_bodypart)

/// Promotes one moderate or severe slash wound on the struck limb.
/datum/power/aberrant/raking_claws_bestial_upgrade/proc/aggravate_bleeding_wound(mob/living/claw_user, obj/item/raking_claw/claw, mob/living/carbon/target, obj/item/bodypart/hit_bodypart)
	var/list/upgradeable_wounds = list()
	for(var/datum/wound/slash/flesh/bleeding_wound in hit_bodypart.wounds)
		if(bleeding_wound.severity == WOUND_SEVERITY_MODERATE || bleeding_wound.severity == WOUND_SEVERITY_SEVERE)
			upgradeable_wounds += bleeding_wound
	if(!length(upgradeable_wounds))
		return

	var/datum/wound/slash/flesh/selected_wound = pick(upgradeable_wounds)
	var/datum/wound/slash/flesh/upgraded_wound
	if(selected_wound.severity == WOUND_SEVERITY_MODERATE)
		upgraded_wound = new /datum/wound/slash/flesh/severe
	else
		upgraded_wound = new /datum/wound/slash/flesh/critical
	selected_wound.replace_wound(upgraded_wound, attack_direction = get_dir(claw_user, target))

	claw_user.visible_message(
		span_danger("[claw_user] tears the wound on [target]'s [hit_bodypart.plaintext_zone] wide open with [claw]!"),
		span_danger("You tear the wound on [target]'s [hit_bodypart.plaintext_zone] wide open with [claw]!"),
	)
