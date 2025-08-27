// osako

/obj/item/gun/ballistic/rifle/osako
	name = "\improper Osako bolt rifle"
	desc = "A seldom regulated bolt action rifle that sees less seldom use on colonies such as New Gibraltar."
	icon = 'modular_doppler/modular_weapons/icons/obj/guns48x.dmi'
	icon_state = "osako"
	lefthand_file = 'modular_doppler/modular_weapons/icons/mob/inhands/gun_lefthand.dmi'
	righthand_file = 'modular_doppler/modular_weapons/icons/mob/inhands/gun_righthand.dmi'
	inhand_icon_state = "osako"
	worn_icon = 'modular_doppler/modular_weapons/icons/mob/worn/guns.dmi'
	worn_icon_state = "osako"
	SET_BASE_PIXEL(-8, 0)
	inhand_x_dimension = 32
	inhand_y_dimension = 32
	weapon_weight = WEAPON_HEAVY
	fire_sound = 'modular_doppler/modular_weapons/sounds/boltie.wav'
	rack_sound = 'modular_doppler/modular_weapons/sounds/boltie_boltout.wav'
	bolt_drop_sound = 'modular_doppler/modular_weapons/sounds/boltie_boltin.wav'
	accepted_magazine_type = /obj/item/ammo_box/magazine/internal/osako
	internal_magazine = TRUE
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_BACK
	can_suppress = FALSE
	can_unsuppress = FALSE
	recoil = 0.25

/obj/item/gun/ballistic/rifle/osako/add_bayonet_point()
	return

/obj/item/ammo_box/magazine/internal/osako
	name = "osako internal magazine"
	desc = "OSACO-CHUCKSTER 2525"
	ammo_type = /obj/item/ammo_casing/c25euro
	caliber = CALIBER_25EUROPA
	max_ammo = 5
	ammo_box_multiload = AMMO_BOX_MULTILOAD_NONE

// crash rifle

/obj/item/gun/ballistic/rifle/crash
	name = "\improper Crash lever rifle"
	desc = "An emergency weapon made to better the quite low survival rates of survivors landing on Truth. \
		While the rifle is made for when you crash, the man responsible for it's adoption is also named the same, \
		believe it or not."
	icon = 'modular_doppler/modular_weapons/icons/obj/guns48x.dmi'
	icon_state = "crash"
	lefthand_file = 'modular_doppler/modular_weapons/icons/mob/inhands/gun_lefthand.dmi'
	righthand_file = 'modular_doppler/modular_weapons/icons/mob/inhands/gun_righthand.dmi'
	inhand_icon_state = "crash"
	worn_icon = 'modular_doppler/modular_weapons/icons/mob/worn/guns.dmi'
	worn_icon_state = "crash"
	SET_BASE_PIXEL(-8, 0)
	inhand_x_dimension = 32
	inhand_y_dimension = 32
	weapon_weight = WEAPON_HEAVY
	fire_sound = 'modular_doppler/modular_weapons/sounds/crash.wav'
	accepted_magazine_type = /obj/item/ammo_box/magazine/internal/crash
	internal_magazine = TRUE
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_BACK
	can_suppress = FALSE
	can_unsuppress = FALSE
	projectile_damage_multiplier = 0.8
	recoil = 0.5

/obj/item/gun/ballistic/rifle/crash/add_bayonet_point()
	return

/obj/item/ammo_box/magazine/internal/crash
	name = "crash rifle internal magazine"
	desc = "I'll make you crash since you saw this. Yeah, you buddy."
	ammo_type = /obj/item/ammo_casing/c25euro
	caliber = CALIBER_25EUROPA
	max_ammo = 7
	ammo_box_multiload = AMMO_BOX_MULTILOAD_NONE
