/**
 * Option Definitions
 */

/datum/signature_equipment/captain_weapon/standard_sabre
	name = "Standard Sabre"
	icon_item_type = /obj/item/melee/sabre
	spawned_item_type = /obj/item/storage/belt/sabre

/datum/signature_equipment/captain_weapon/alternate_sabre
	name = "Alternate Sabre"
	icon_item_type = /obj/item/melee/sabre/modular/alternate
	spawned_item_type = /obj/item/storage/belt/sabre/modular/alternate

/datum/signature_equipment/captain_weapon/golden_sabre
	name = "Golden Sabre"
	icon_item_type = /obj/item/melee/sabre/modular/golden
	spawned_item_type = /obj/item/storage/belt/sabre/modular/golden

/datum/signature_equipment/captain_weapon/cane_sabre
	name = "Cane Sabre"
	desc = "The sheath for this sabre is a cane, and doesn't fit on belts."
	icon_item_type = /obj/item/melee/sabre/modular/cane
	spawned_item_type = /obj/item/storage/belt/sabre/modular/cane

/datum/signature_equipment/captain_weapon/telescopic_sabre
	name = "Telescopic Sabre (Sheathless)"
	desc = "A retractable blade makes this option easier to conceal, but less effective compared to the other sabres."
	icon_item_type = /obj/item/melee/sabre/modular/telescopic
	icon_state = "sabre_telescopic_on" // It's telescopic, force it to be extended for the selection menu image.
	spawned_item_type = /obj/item/melee/sabre/modular/telescopic


/**
 * Item Overrides
 */

/obj/item/storage/belt/sabre
	storage_type = /datum/storage/sabre_belt/no_modulars

/datum/storage/sabre_belt/no_modulars/New(atom/parent, max_slots, max_specific_storage, max_total_storage, rustle_sound, remove_rustle_sound)
	. = ..()
	set_holdable(
		can_hold_list = list(
			/obj/item/melee/sabre,
		),
		cant_hold_list = list(
			/obj/item/melee/sabre/modular, // Block modular sabres from fitting into the base sabre belt
		)
	)


/**
 * Item Definitions
 */

/obj/item/melee/sabre/modular
	icon = 'modular_doppler/modular_weapons/icons/obj/captain_sabres.dmi'
	lefthand_file = 'modular_doppler/modular_weapons/icons/mob/inhands/captain_sabres_lefthand.dmi'
	righthand_file = 'modular_doppler/modular_weapons/icons/mob/inhands/captain_sabres_righthand.dmi'

/obj/item/storage/belt/sabre/modular
	icon = 'modular_doppler/modular_weapons/icons/obj/captain_sheaths.dmi'
	worn_icon = 'modular_doppler/modular_weapons/icons/mob/worn/captain_sheaths.dmi'
	lefthand_file = 'modular_doppler/modular_weapons/icons/mob/inhands/captain_sheaths_lefthand.dmi'
	righthand_file = 'modular_doppler/modular_weapons/icons/mob/inhands/captain_sheaths_righthand.dmi'
	icon_state = "sheath_alternate"
	storage_type = /datum/storage/sabre_belt/modular
	/// The type of the sword we spawn with and can hold.
	var/spawned_sword_type

/obj/item/storage/belt/sabre/modular/PopulateContents()
	if(isnull(spawned_sword_type))
		return
	new spawned_sword_type(src)
	update_appearance()

/datum/storage/sabre_belt/modular/New(atom/parent, max_slots, max_specific_storage, max_total_storage, rustle_sound, remove_rustle_sound)
	. = ..()
	if(!istype(parent, /obj/item/melee/sabre/modular))
		return
	var/obj/item/storage/belt/sabre/modular/modular_belt_parent = parent
	if(isnull(modular_belt_parent.spawned_sword_type))
		return
	set_holdable(modular_belt_parent.spawned_sword_type)


/obj/item/melee/sabre/modular/alternate
	icon_state = "sabre_alternate"
	inhand_icon_state = "sabre_alternate"

/obj/item/storage/belt/sabre/modular/alternate
	icon_state = "sheath_alternate"
	inhand_icon_state = "sheath_alternate"
	worn_icon_state = "sheath_alternate"
	spawned_sword_type = /obj/item/melee/sabre/modular/alternate


/obj/item/melee/sabre/modular/golden
	name = "black-golden sabre"
	desc = "An elegantly designed officer's sabre. \
	Although its design budget was certainly higher, its blade is no more nor less effective"
	icon_state = "sabre_golden"
	inhand_icon_state = "sabre_golden"

/obj/item/storage/belt/sabre/modular/golden
	icon_state = "sheath_golden"
	inhand_icon_state = "sheath_golden"
	worn_icon_state = "sheath_golden"
	spawned_sword_type = /obj/item/melee/sabre/modular/golden


/obj/item/melee/sabre/modular/cane
	name = "cane sabre"
	desc = "A thin blade designed to slot neatly into a cane."
	icon_state = "sabre_cane"
	inhand_icon_state = "sabre_cane"

/obj/item/storage/belt/sabre/modular/cane
	name = "cane sheath"
	desc = "A walking cane modified to hold a thin stick sabre. Notably, it does not fit on belts."
	icon_state = "sheath_cane"
	inhand_icon_state = "sheath_cane"
	worn_icon_state = "sheath_cane"

	slot_flags = NONE // This doesn't fit on belts, it's a cane. (we don't have a sprite for it)
	spawned_sword_type = /obj/item/melee/sabre/modular/cane


/obj/item/melee/sabre/modular/telescopic
	name = "telescopic blade"
	desc = "A telescopic and retractable blade designed for easy concealment and carry. \
	On the flipside, this comes at the sacrifice of effectiveness as a blade."
	icon_state = "sabre_telescopic"
	inhand_icon_state = "sabre_telescopic"
	worn_icon = 'modular_doppler/modular_weapons/icons/mob/worn/captain_sabres.dmi'
	worn_icon_state = "sabre_telescopic" // Yes, this is invisible.

	slot_flags = ITEM_SLOT_BELT
	w_class = WEIGHT_CLASS_SMALL
	attack_verb_continuous = list("smacks", "prods")
	attack_verb_simple = list("smack", "prod")

	force = 0
	throwforce = 0
	
	/// The sound we play when extending.
	var/extend_sound = 'sound/items/unsheath.ogg'
	/// The sound we play when retracting.
	var/retract_sound = 'sound/items/sheath.ogg'

	// Extended stat block.
	/// Force when extended.
	var/force_on = 10
	/// Block chance when extended.
	var/block_chance_on = 40
	/// Armour penetration when extended.
	var/armour_penetration_on = 75
	/// Wound bonus when extended.
	var/wound_bonus_on = 10
	/// Exposed wound bonus when extended.
	var/exposed_wound_bonus_on = 25
	/// Slot flags when extended.
	var/slot_flags_extended = NONE

	// Retracted stat block.
	/// Slot flags when retracted.
	var/slot_flags_retracted = ITEM_SLOT_BELT

/obj/item/melee/sabre/modular/telescopic/Initialize(mapload)
	. = ..()
	AddComponent( \
		/datum/component/transforming, \
		force_on = force_on, \
		throwforce_on = force_on, \
		hitsound_on = hitsound, \
		w_class_on = WEIGHT_CLASS_BULKY, \
		clumsy_check = FALSE, \
		attack_verb_continuous_on = list("slashes", "cuts"), \
		attack_verb_simple_on = list("slash", "cut"), \
	)
	RegisterSignal(src, COMSIG_TRANSFORMING_ON_TRANSFORM, PROC_REF(on_transform))
	set_retracted_state()

/// Removes/adds everything for our retracted state.
/obj/item/melee/sabre/modular/telescopic/proc/set_retracted_state()
	// Remove all components, elements, and signals.
	qdel(GetComponent(/datum/component/jousting))
	qdel(GetComponent(/datum/component/butchering))
	RemoveElement(/datum/element/bane, target_type = /mob/living/carbon/human, damage_multiplier = 0.35)
	UnregisterSignal(src, list(COMSIG_OBJECT_PRE_BANING, COMSIG_OBJECT_ON_BANING))

	// Zero out our stat block.
	block_chance = 0
	armour_penetration = 0
	wound_bonus = 0
	exposed_wound_bonus = 0
	slot_flags = slot_flags_retracted

/// Removes/adds everything for our extended state.
/obj/item/melee/sabre/modular/telescopic/proc/set_extended_state()
	// Re-add all components, elements, and signals.
	AddComponent(/datum/component/jousting)
	AddComponent(/datum/component/butchering, \
		speed = 3 SECONDS, \
		effectiveness = 95, \
		bonus_modifier = 5, \
	)
	AddElement(/datum/element/bane, target_type = /mob/living/carbon/human, damage_multiplier = 0.35)
	RegisterSignal(src, COMSIG_OBJECT_PRE_BANING, PROC_REF(attempt_bane))
	RegisterSignal(src, COMSIG_OBJECT_ON_BANING, PROC_REF(bane_effects))

	// Reset our stat block.
	block_chance = block_chance_on
	armour_penetration = armour_penetration_on
	wound_bonus = wound_bonus_on
	exposed_wound_bonus = exposed_wound_bonus_on
	slot_flags = slot_flags_extended

/obj/item/melee/sabre/modular/telescopic/proc/on_transform(obj/item/source, mob/user, active)
	SIGNAL_HANDLER

	if(active)
		set_extended_state()
	else
		set_retracted_state()

	if(user)
		balloon_alert(user, active ? "extended" : "collapsed")
	playsound(src, active ? extend_sound : retract_sound, 25, TRUE)
	return COMPONENT_NO_DEFAULT_MESSAGE
