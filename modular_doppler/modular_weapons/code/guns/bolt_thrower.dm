/*
* a tiziran assault weapon that accelerates rods through skulls with the power of electromagnetism. it's for pirates to kill people with.
* mechanically it's like semi automatic rebar crossbow and is designed to break security's unprotected kneecaps
*/

/obj/item/gun/ballistic/bolt_thrower
	name = "bolt thrower"
	desc = "Tiziran small arms often feature electromagnetic drivers in lieu of propellant in an effort to prevent \
	errant sparks from igniting low lying puddles of subterranean gasses. This effort is often rendered fruitless \
	when field operators overtune their coils for greater penetration until the projectile spall itself ignites."
	icon = 'modular_doppler/modular_weapons/icons/obj/guns32x.dmi'
	icon_state = "bolt_thrower"
	worn_icon = 'modular_doppler/modular_weapons/icons/mob/worn/guns.dmi'
	worn_icon_state = "bolt_thrower"
	lefthand_file = 'modular_doppler/modular_weapons/icons/mob/inhands/gun_lefthand.dmi'
	righthand_file = 'modular_doppler/modular_weapons/icons/mob/inhands/gun_righthand.dmi'
	inhand_icon_state = "bolt_thrower"
	slot_flags = ITEM_SLOT_BACK | ITEM_SLOT_SUITSTORE
	accepted_magazine_type = /obj/item/ammo_box/magazine/internal/bolt_thrower
	internal_magazine = TRUE
	mag_display = TRUE
	mag_display_ammo = TRUE
	fire_delay = 10
	fire_sound = 'modular_doppler/modular_sounds/sound/items/bolt_thrower.ogg'
	weapon_weight = WEAPON_HEAVY
	cartridge_wording = "slug"

/obj/item/ammo_box/magazine/internal/bolt_thrower
	name = "bolt thrower internal magazine"
	ammo_type = /obj/item/ammo_casing/bolt_slug
	caliber = CALIBER_BOLT_THROWER
	max_ammo = 5
