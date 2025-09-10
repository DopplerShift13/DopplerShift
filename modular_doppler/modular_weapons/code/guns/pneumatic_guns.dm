
/*
*	A gun that shoots stingballs, intended to be a doppler-flavored replacement for the tgstation disabler
*/

/obj/item/gun/ballistic/avispa_stingball_shooter
	name = "\improper Avispa stingball launcher"	//avispa means wasp
	desc = "Oriented glass strand polymers in hivis yellow and blackened pneumatic tubing. The strange and uncomfortable stock \
	was designed for legalistic concerns over ergonomics. A label on the side admonishes the use of third party ammunition and \
	recommends against aiming for a target's eyes."
	icon = 'modular_doppler/modular_weapons/icons/obj/guns32x.dmi'
	icon_state = "avispa"
	worn_icon = 'modular_doppler/modular_weapons/icons/mob/worn/guns.dmi'
	worn_icon_state = "avispa"
	lefthand_file = 'modular_doppler/modular_weapons/icons/mob/inhands/gun_lefthand.dmi'
	righthand_file = 'modular_doppler/modular_weapons/icons/mob/inhands/gun_righthand.dmi'
	inhand_icon_state = "avispa"
	fire_sound = 'sound/items/weapons/peashoot.ogg'
	w_class = WEIGHT_CLASS_BULKY
	weapon_weight = WEAPON_HEAVY
	slot_flags = ITEM_SLOT_BACK
	force = 10
	accepted_magazine_type = /obj/item/ammo_box/magazine/internal/avispa_stingball_shooter
	internal_magazine = TRUE
	bolt_type = BOLT_TYPE_OPEN
	show_bolt_icon = FALSE
	tac_reloads = FALSE
	burst_size = 2
	custom_price = PAYCHECK_CREW * 7

/obj/item/ammo_box/magazine/internal/avispa_stingball_shooter
	name = "stingball hopper"
	ammo_type = /obj/item/ammo_casing/avispa_stingball
	caliber = CALIBER_STINGBALL
	max_ammo = 38

/*
*	a syringe gun with a constrained set of pre-filled cartridges that it can load, for security's support loadout.
* 	we want sealed and tamper-proof darts for this, so we subtype from /obj/item/gun/ballistic instead of /obj/item/gun/syringe
*	and avoid syringes entirely.
*/

/obj/item/gun/ballistic/alacran
	name = "\improper Alacrán syringe delivery system"	//alacran means scorpion
	desc = "A pneumatically driven dart pistol that has found broad popularity with trauma response units for its usability, \
	and with trauma response corporate lawyers for its liability-friendly sealed and proprietary cartridges."
	icon = 'modular_doppler/modular_weapons/icons/obj/guns32x.dmi'
	icon_state = "alacran"
	worn_icon = 'modular_doppler/modular_weapons/icons/mob/worn/guns.dmi'
	worn_icon_state = "alacran"
	lefthand_file = 'modular_doppler/modular_weapons/icons/mob/inhands/gun_lefthand.dmi'
	righthand_file = 'modular_doppler/modular_weapons/icons/mob/inhands/gun_righthand.dmi'
	inhand_icon_state = "alacran"
	w_class = WEIGHT_CLASS_SMALL
	slot_flags = ITEM_SLOT_BELT | ITEM_SLOT_SUITSTORE
	accepted_magazine_type = /obj/item/ammo_box/magazine/internal/alacran
	internal_magazine = TRUE
	bolt_type = BOLT_TYPE_LOCKING
	can_suppress = FALSE
	cartridge_wording = "dart"

/obj/item/ammo_box/magazine/internal/alacran
	name = "Alacrán bolt"
	ammo_type = /obj/item/ammo_casing/alacran_dart
	caliber = CALIBER_ALACRAN
	max_ammo = 1
