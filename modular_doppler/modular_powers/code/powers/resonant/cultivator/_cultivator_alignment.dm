/*
	Because Cultivator's alignments have a consistent throughline fo behavior, the alignment powers are subtyped like so.
	Set up to be modular and also very VV-able; because its cool if some event antag shows up in a color that nobody knows.
*/
/datum/action/cooldown/power/cultivator/alignment
	name = "abstract alignment"

	/// The size of the glow effect around the mob for alignment.
	var/alignment_outline_size = 2
	/// The overlay color for alignment, if it has one
	var/alignment_outline_color = "#66d5dd"
	/// The name for the filter (dont need to change this)
	var/filter_id = "alignment_outline"

	/// Light object for the alignment
	var/obj/effect/dummy/lighting_obj/moblight/alignment_light
	/// Sounds to play when activating alignment
	var/alignment_activation_sound = 'sound/effects/magic/lightningbolt.ogg'

	/// Mutable appearance stuff for the overlay.
	var/mutable_appearance/alignment_overlay
	/// Icon for the effect sprite of the alignment overlay. This is distinct from the outline, but IS affected by the outline.
	var/alignment_overlay_icon = 'icons/effects/effects.dmi'
	/// Icon state for the efffect sprite of the alignment overlay.
	var/alignment_overlay_state = "lightning"
	/// Layer on which the effect sprite sits for the alignment overlay
	var/alignment_overlay_layer = ABOVE_MOB_LAYER

	/// The armor datum given when in alignment. You SHOULD modify this if you want to change the armor type.
	var/datum/armor/alignment_defense = /datum/armor/alignment_unarmored_defense
	/// The armor datum we actually add after comparing current armor against alignment_defense. You should NOT need to modify this.
	var/datum/armor/alignment_added_armor
	/// The damage type for the alignment
	var/alignment_damage_type = BRUTE
	/// The bonus damage for the alignment
	var/alignment_damage_bonus = CULTIVATOR_ALIGNMENT_DAMAGE_BONUS
	/// The upkeep cost of the alignment
	var/alignment_upkeep_cost = CULTIVATOR_ALIGNMENT_UPKEEP_COST

	cooldown_time = 5 // to prevent spam-clicking it off
	contributes_to_aura_farming = TRUE // needs to be always be on or you won't get aura from alignment
	cost = CULTIVATOR_ALIGNMENT_ACTIVATION_COST

// Removes stray listeners.
/datum/action/cooldown/power/cultivator/alignment/Destroy()
	. = ..()
	if(owner)
		UnregisterSignal(owner, list(COMSIG_HUMAN_UNARMED_HIT, COMSIG_MOB_EQUIPPED_ITEM, COMSIG_MOB_UNEQUIPPED_ITEM, COMSIG_ATOM_DISPEL))
		remove_alignment_armor()

/// The proc for onhit. Override as desired.
/datum/action/cooldown/power/cultivator/alignment/proc/on_unarmed_hit(mob/living/user, mob/living/target, obj/item/bodypart/affecting, damage, armor_block, limb_sharpness)
	SIGNAL_HANDLER
	if(!active)
		return
	if(alignment_damage_bonus)
		apply_damage_with_armor(target, alignment_damage_bonus, alignment_damage_type, affecting, armor_block, attack_flag = MELEE)

// Basically handles active state and activation fx. Override as needed; but please make sure to get the essentials.
/datum/action/cooldown/power/cultivator/alignment/use_action(mob/living/carbon/user)
	if(!active) // If inactive, we activate (if we can pay the cost)
		enable_alignment(user)
		return TRUE
	if(active) // If active, we disable.
		disable_alignment(user)
		return TRUE
	return FALSE

/// COOL effects to show your AURA.
/datum/action/cooldown/power/cultivator/alignment/proc/activation_fx(mob/living/carbon/user, atom/target)
	if(isnull(alignment_outline_color) && isnull(alignment_outline_size))
		return
	// Adds the color effects
	user.remove_filter(filter_id)
	user.add_filter(filter_id, 2, outline_filter(size = alignment_outline_size, color = alignment_outline_color))

	var/filter = user.get_filter(filter_id)
	if(filter)
		animate(filter, alpha = 110, time = 1.5 SECONDS, loop = -1)
		animate(alpha = 40, time = 2.5 SECONDS)

	// Adds the glowing light.
	QDEL_NULL(alignment_light)
	alignment_light = user.mob_light(
		range = 3,
		power = 1,
		color = alignment_outline_color
	)
	// adds overlay
	if(!alignment_overlay)
		alignment_overlay = mutable_appearance(alignment_overlay_icon, alignment_overlay_state, alignment_overlay_layer)
	alignment_overlay.color = alignment_outline_color
	user.add_overlay(alignment_overlay)

	// plays sound
	playsound(owner, alignment_activation_sound, 75, TRUE, MEDIUM_RANGE_SOUND_EXTRARANGE)

/// Everything that needs to happen when enabling alignment
/datum/action/cooldown/power/cultivator/alignment/proc/enable_alignment(mob/living/carbon/user)
	active = TRUE
	bypass_cost = TRUE // makes it so we don't check for cost next time.
	activation_fx(user)
	RegisterSignal(user, COMSIG_HUMAN_UNARMED_HIT, PROC_REF(on_unarmed_hit))
	RegisterSignal(user, COMSIG_MOB_EQUIPPED_ITEM, PROC_REF(on_equipment_changed))
	RegisterSignal(user, COMSIG_MOB_UNEQUIPPED_ITEM, PROC_REF(on_equipment_changed))
	RegisterSignal(user, COMSIG_ATOM_DISPEL, PROC_REF(on_dispel))
	recompute_alignment_armor(user)
	SEND_SIGNAL(user, COMSIG_CULTIVATOR_ALIGNMENT_ENABLED, src)
	return TRUE

/// Everything that needs to happen when disabling alignment
/datum/action/cooldown/power/cultivator/alignment/proc/disable_alignment(mob/living/carbon/user)
	active = FALSE
	bypass_cost = FALSE
	if(alignment_overlay)
		user.cut_overlay(alignment_overlay)
		QDEL_NULL(alignment_overlay)
	UnregisterSignal(user, list(COMSIG_HUMAN_UNARMED_HIT, COMSIG_MOB_EQUIPPED_ITEM, COMSIG_MOB_UNEQUIPPED_ITEM, COMSIG_ATOM_DISPEL))
	user.remove_filter(filter_id)
	remove_alignment_armor()
	QDEL_NULL(alignment_light)
	SEND_SIGNAL(user, COMSIG_CULTIVATOR_ALIGNMENT_DISABLED, src)
	return TRUE

/// Dispel handler: drains Energy if alignment is active.
/// For balance reasons this should not end on dispel; it is really an all eggs in one basket power.
/datum/action/cooldown/power/cultivator/alignment/proc/on_dispel(mob/owner, atom/dispeller)
	SIGNAL_HANDLER
	if(!active)
		return NONE
	if(ValidateEnergyComponent())
		adjust_energy(-CULTIVATOR_ENERGY_MODERATE)
	return DISPEL_RESULT_DISPELLED

// Deactivating the power doesn't cost anything so we skip the cost component.
/datum/action/cooldown/power/cultivator/alignment/on_action_success(mob/living/carbon/user)
	if(!active)
		return
	else
		. = ..()

/*
	Below is the big scary block of 'how to maths out other armor'
	Because we want armor to never EXCEED the alignment due to stacking armor items with alignment, we need to COMPARE it against the current armor and change the armor values on the fly.
	This is called when either A. you activate the alignment or B. equip/unequip stuff.
	'Other armor' as a type applies globally to all slots, so wearing a really good helmet/chest will still disable the alignment damage bonus for other slots that may be uncovered.
*/

/// Whenever we change anything about our loadout, recompute.
/datum/action/cooldown/power/cultivator/alignment/proc/on_equipment_changed(datum/source, obj/item/item, slot)
	SIGNAL_HANDLER
	if(!active)
		return
	recompute_alignment_armor(source)

/// The builder that actually applies the maths from calc_needed_internal_armor and applies it.
/datum/action/cooldown/power/cultivator/alignment/proc/recompute_alignment_armor(mob/living/carbon/user)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/human_user = user

	remove_alignment_armor()

	var/datum/armor/target_armor = alignment_defense
	if(ispath(target_armor))
		target_armor = get_armor_by_type(target_armor)

	var/list/add_values = list()
	for(var/armor_type in ARMOR_LIST_ALL())
		var/target_total = target_armor.get_rating(armor_type)
		var/needed = calc_needed_internal_armor(human_user, armor_type, target_total)
		if(needed > 0)
			add_values[armor_type] = needed

	if(LAZYLEN(add_values))
		var/datum/armor/base_armor = new /datum/armor
		alignment_added_armor = base_armor.generate_new_with_specific(add_values)
		human_user.physiology.armor = human_user.physiology.armor.add_other_armor(alignment_added_armor)

/// Compares the user's current worn armor against the armor from alignment_defense and returns the difference, to ensure we don't stack alignment armor past 40 armor.
/datum/action/cooldown/power/cultivator/alignment/proc/calc_needed_internal_armor(mob/living/carbon/human/human_target, armor_type, target_total)
	var/list/covering_clothing = list(
		human_target.head, human_target.wear_mask, human_target.wear_suit, human_target.w_uniform, human_target.back, human_target.gloves, human_target.shoes, human_target.belt, human_target.s_store,	human_target.glasses, human_target.ears, human_target.wear_id, human_target.wear_neck)

	var/clothing_multiplier = 1.0
	for(var/obj/item/clothing/clothing_item in covering_clothing)
		if(!clothing_item)
			continue
		var/clothing_rating = min(clothing_item.get_armor_rating(armor_type), 100)
		clothing_multiplier *= (100 - clothing_rating) * 0.01

	var/current_internal = human_target.physiology.armor.get_rating(armor_type)
	var/current_total = human_target.getarmor(null, armor_type)
	if(current_total >= target_total)
		return 0

	var/required_internal = 100 * (1 - (1 - target_total / 100) / max(clothing_multiplier, 0.0001))
	return max(0, required_internal - current_internal)

/// Removes the lingering effects of the alignment armor.
/datum/action/cooldown/power/cultivator/alignment/proc/remove_alignment_armor()
	if(!alignment_added_armor || !ishuman(owner))
		alignment_added_armor = null
		return
	var/mob/living/carbon/human/human_owner = owner
	human_owner.physiology.armor = human_owner.physiology.armor.subtract_other_armor(alignment_added_armor)
	alignment_added_armor = null

// base armor for alignment powers.
/datum/armor/alignment_unarmored_defense
	acid = 40
	bio = 40
	melee = 40
	bullet = 40
	bomb = 40
	energy = 40
	laser = 40
	fire = 40
	melee = 40
	wound = 40
